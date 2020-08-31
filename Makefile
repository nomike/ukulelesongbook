SHELL := /bin/bash -O nullglob
all: regular single hardcover
regular: ukulele guitar
single: out/songbook-guitar-single.pdf out/songbook-ukulele-single.pdf
ukulele: out/songbook-ukulele.pdf
guitar: out/songbook-guitar.pdf
cover-ukulele: cover/cover-ukulele.pdf
cover-guitar: cover/cover-guitar.pdf

out:
	mkdir -p out

out/songbook-ukulele.pdf : out songs/*.chopro chordpro-ukulele.json cover/cover-ukulele.pdf build/ukulele.songlist
	CHORDPRO_PDF="PDF::API2" ./create_songbook.py --instrument ukulele

out/songbook-guitar.pdf : out songs/*.chopro chordpro-guitar.json cover/cover-guitar.pdf build/guitar.songlist
	CHORDPRO_PDF="PDF::API2" ./create_songbook.py --instrument guitar

clean-vscode: clean
	rm -f cover/cover-guitar.aux cover/cover-guitar.fdb_latexmk cover/cover-guitar.fls cover/cover-guitar.log cover/cover-guitar.synctex.gz cover/cover-ukulele.aux cover/cover-ukulele.fdb_latexmk cover/cover-ukulele.fls cover/cover-ukulele.log cover/cover-ukulele.synctex.gz

clean: clean-build clean-out
	rm -f cover/cover-guitar.pdf cover/cover-guitar.aux cover/cover-guitar.log cover/cover-guitar.tex cover/cover-ukulele.pdf cover/cover-ukulele.aux cover/cover-ukulele.log cover/cover-ukulele.tex

clean-build:
	rm -rf build/

clean-out:
	rm -rf out/

cover/cover-ukulele.tex: cover/cover-ukulele.tex.tpl COMMIT-HASH COMMIT-HASH-songs configuration
	. ./configuration ; envsubst <cover/cover-ukulele.tex.tpl >cover/cover-ukulele.tex

cover/cover-guitar.tex: cover/cover-guitar.tex.tpl COMMIT-HASH COMMIT-HASH-songs configuration
	. ./configuration ; envsubst <cover/cover-guitar.tex.tpl >cover/cover-guitar.tex

cover/cover-ukulele.pdf: cover/cover-ukulele.tex
	(cd cover; pdflatex cover-ukulele.tex)

cover/cover-guitar.pdf: cover/cover-guitar.tex
	(cd cover; pdflatex cover-guitar.tex)

convert: convert-ultimate convert-tabs

convert-tabs:
	( shopt -s nullglob; for i in songs/*.tab ; do chordpro --a2crd "$${i}" | grep -v "LYRICS" | grep -v "is not a valid chord." > "$${i%.tab}.chopro" ; rm -f "$${i}" ; done )

convert-ultimate:
	( shopt -s nullglob; for i in songs/*.ult ; do ./convert_ultimate.py "$${i}" > "$${i%.ult}.tab" ; rm -f "$${i}" ; done )

build/empty.pdf:
	convert xc:none -page A4 build/empty.pdf

build/guitar/toc.txt:
	mkdir -p build/guitar/ ; (cd songs ; find . -type f -a -name "*.chopro" -a ! -name "*-ukulele.chopro") | cut -c 3- | sed 's/\(-guitar\)\{0,1\}\.chopro$$//' | sort > build/guitar/toc.txt

build/guitar/toc.ps: build/guitar/toc.txt
	cat build/guitar/toc.txt | iconv -c --from-code utf-8 --to-code ISO-8859-1 | enscript --margins=30::40: --encoding=88591 --font=Helvetica@12 --no-header --output=build/guitar/toc.ps 

build/guitar/toc.pdf: build/guitar/toc.ps
	ps2pdf build/guitar/toc.ps build/guitar/toc.pdf

out/songbook-guitar-single.pdf: out build/guitar/toc.pdf build/empty.pdf songs/*.chopro chordpro-guitar.json cover/cover-guitar.pdf
	./create_single_songbook.sh guitar ukulele

build/ukulele/toc.txt:
	mkdir -p build/ukulele/ ; (cd songs ; find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro") | cut -c 3- | sed 's/\(-ukulele\)\{0,1\}\.chopro$$//' | sort > build/ukulele/toc.txt

build/ukulele/toc.ps: build/ukulele/toc.txt
	cat build/ukulele/toc.txt | iconv -c --from-code utf-8 --to-code ISO-8859-1 | enscript --margins=30::40: --encoding=88591 --font=Helvetica@12 --no-header --output=build/ukulele/toc.ps 

build/ukulele/toc.pdf: build/ukulele/toc.ps
	ps2pdf build/ukulele/toc.ps build/ukulele/toc.pdf

out/songbook-ukulele-single.pdf: out build/ukulele/toc.pdf build/empty.pdf songs/*.chopro chordpro-ukulele.json cover/cover-ukulele.pdf
	./create_single_songbook.sh ukulele guitar

upload-ukulele: out/songbook-ukulele.pdf
	scp out/songbook-ukulele.pdf nomike@david-brearley.dreamhost.com:nomike.com/public/.ukulelesongbook/

upload-guitar: out/songbook-guitar.pdf
	scp out/songbook-guitar.pdf nomike@david-brearley.dreamhost.com:nomike.com/public/.ukulelesongbook/

upload-ukulele-single: out/songbook-ukulele-single.pdf
	scp out/songbook-ukulele-single.pdf nomike@david-brearley.dreamhost.com:nomike.com/public/.ukulelesongbook/

upload-guitar-single: out/songbook-guitar-single.pdf
	scp out/songbook-guitar-single.pdf nomike@david-brearley.dreamhost.com:nomike.com/public/.ukulelesongbook/

upload: all upload-ukulele upload-guitar upload-ukulele-single upload-guitar-single

build/ukulele.songlist: songs/*.chopro
	./create_songlist.py --instrument=ukulele > build/ukulele.songlist

build/guitar.songlist: songs/*.chopro
	./create_songlist.py --instrument=guitar > build/guitar.songlist


cover/hardcover-ukulele.tex: cover/cover-ukulele.tex.tpl COMMIT-HASH COMMIT-HASH-songs configuration
	export nusb_version="" ; envsubst <cover/cover-ukulele.tex.tpl >cover/hardcover-ukulele.tex

cover/hardcover-guitar.tex: cover/cover-guitar.tex.tpl COMMIT-HASH COMMIT-HASH-songs configuration
	export nusb_version="" ; envsubst <cover/cover-guitar.tex.tpl >cover/hardcover-guitar.tex

cover/hardcover-ukulele.pdf: cover/hardcover-ukulele.tex
	(cd cover; pdflatex hardcover-ukulele.tex)

cover/hardcover-guitar.pdf: cover/hardcover-guitar.tex
	(cd cover; pdflatex hardcover-guitar.tex)

hardcover-ukulele: cover/hardcover-ukulele.pdf

hardcover-guitar: cover/hardcover-guitar.pdf

hardcover: hardcover-ukulele hardcover-guitar

COMMIT-HASH: FORCE
	./update_commit_hashes.sh

COMMIT-HASH-songs: FORCE
	./update_commit_hashes.sh songs

FORCE: