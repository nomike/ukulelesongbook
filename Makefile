all: ukulele guitar
ukulele: out/songbook-ukulele.pdf
guitar: out/songbook-guitar.pdf
cover-ukulele: cover/cover-ukulele.pdf
cover-guitar: cover/cover-guitar.pdf

out:
	mkdir -p out

out/songbook-ukulele.pdf : out songs/*.chopro chordpro-ukulele.json cover/cover-ukulele.pdf ukulele-songlist
	CHORDPRO_PDF="PDF::API2" ./create_songbook.py --instrument ukulele

out/songbook-guitar.pdf : out songs/*.chopro chordpro-guitar.json cover/cover-guitar.pdf guitar-songlist
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

convert-tabs:
	for i in songs/*.tab ; do chordpro --a2crd "$${i}" > "$${i%.tab}.chopro" ; rm -f "$${i}" ; done
