SHELL := /bin/bash -O nullglob
all: regular single
regular: ukulele guitar
single: out/songbook-guitar-single.pdf out/songbook-ukulele-single.pdf
ukulele: out/songbook-ukulele.pdf
guitar: out/songbook-guitar.pdf
cover-ukulele: cover/cover-ukulele.pdf
cover-guitar: cover/cover-guitar.pdf

out:
	mkdir -p out

out/songbook-ukulele.pdf : out songs/*.chopro chordpro-ukulele.json cover/cover-ukulele.pdf songlist-ukulele
	CHORDPRO_PDF="PDF::API2" ./create_songbook.py --instrument ukulele

out/songbook-guitar.pdf : out songs/*.chopro chordpro-guitar.json cover/cover-guitar.pdf songlist-guitar
	CHORDPRO_PDF="PDF::API2" ./create_songbook.py --instrument guitar

clean-vscode: clean
	rm -f cover/cover-guitar.aux cover/cover-guitar.fdb_latexmk cover/cover-guitar.fls cover/cover-guitar.log cover/cover-guitar.synctex.gz cover/cover-ukulele.aux cover/cover-ukulele.fdb_latexmk cover/cover-ukulele.fls cover/cover-ukulele.log cover/cover-ukulele.synctex.gz

clean: clean-out
	rm -f cover/cover-guitar.pdf cover/cover-guitar.aux cover/cover-guitar.log cover/cover-guitar.tex cover/cover-ukulele.pdf cover/cover-ukulele.aux cover/cover-ukulele.log cover/cover-ukulele.tex

clean-out:
	rm -rf out/

cover/cover-ukulele.tex: cover/cover-ukulele.tex.tpl configuration
	. ./configuration ; export nusb_version ; envsubst <cover/cover-ukulele.tex.tpl >cover/cover-ukulele.tex

cover/cover-guitar.tex: cover/cover-guitar.tex.tpl configuration
	. ./configuration ; export nusb_version ; envsubst <cover/cover-guitar.tex.tpl >cover/cover-guitar.tex

cover/cover-ukulele.pdf: cover/cover-ukulele.tex
	(cd cover; pdflatex cover-ukulele.tex)

cover/cover-guitar.pdf: cover/cover-guitar.tex
	(cd cover; pdflatex cover-guitar.tex)

convert: convert-ultimate convert-tabs

convert-tabs:
	( shopt -s nullglob; cd songs ; for i in *.tab ; do chordpro --a2crd "$${i}" | grep -v "LYRICS" | grep -v "is not a valid chord." > "$${i%.tab}.chopro" ; rm -f "$${i}" ; done )

convert-ultimate:
	( shopt -s nullglob; cd songs ; for i in *.ult ; do ../convert_ultimate "$${i}" > "$${i%.ult}.tab" ; rm -f "$${i}" ; done )

build/empty.pdf:
	convert xc:none -page A4 build/empty.pdf

build/guitar/toc.txt:
	mkdir -p build/guitar/ ; (cd songs ; find . -type f -a -name "*.chopro" -a ! -name "*-ukulele.chopro") | cut -c 3- | sed 's/\(-guitar\)\{0,1\}\.chopro$$//' | sort > build/guitar/toc.txt

build/guitar/toc.ps: build/guitar/toc.txt
	enscript -Bp build/guitar/toc.ps build/guitar/toc.txt

build/guitar/toc.pdf: build/guitar/toc.ps
	ps2pdf build/guitar/toc.ps build/guitar/toc.pdf

out/songbook-guitar-single.pdf: out build/guitar/toc.pdf build/empty.pdf songs/*.chopro chordpro-guitar.json cover/cover-guitar.pdf
	./create_single_songbook.sh guitar ukulele

build/ukulele/toc.txt:
	mkdir -p build/ukulele/ ; (cd songs ; find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro") | cut -c 3- | sed 's/\(-ukulele\)\{0,1\}\.chopro$$//' | sort > build/ukulele/toc.txt

build/ukulele/toc.ps: build/ukulele/toc.txt
	enscript -Bp build/ukulele/toc.ps build/ukulele/toc.txt

build/ukulele/toc.pdf: build/ukulele/toc.ps
	ps2pdf build/ukulele/toc.ps build/ukulele/toc.pdf

out/songbook-ukulele-single.pdf: out build/ukulele/toc.pdf build/empty.pdf songs/*.chopro chordpro-ukulele.json cover/cover-ukulele.pdf
	./create_single_songbook.sh ukulele guitar
