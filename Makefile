SHELL := /bin/bash -O nullglob
all: regular printshop
.PHONY: all printshop regular cover-ukulele cover-guitar clean clean-vscode clean-build clean-out convert convert-tabs convert-ultimate ukulele
printshop: out/songbook-ukulele-printshop.pdf out/songbook-guitar-printshop.pdf
regular: out/songbook-guitar.pdf out/songbook-ukulele.pdf
cover-ukulele: newcover/ukulele.pdf
cover-guitar: newcover/guitar.pdf

out/songbook-ukulele-printshop.pdf: songs/*.chopro chordpro-ukulele.json newcover/ukulele.pdf build/ukulele.songlist
	./create_printshop_songbook.py --instrument ukulele

out/songbook-guitar-printshop.pdf: songs/*.chopro chordpro-guitar.json newcover/guitar.pdf build/guitar.songlist
	./create_printshop_songbook.py --instrument guitar

clean: clean-newcover clean-build clean-out

clean-newcover:
	rm -f newcover/src/ukuleleVariables.sty newcover/src/guitarVariables.sty newcover/*.aux newcover/*.fdb_latexmk newcover/*.fls newcover/*.idx newcover/*.log newcover/*.out newcover/*.pdf newcover/*.ilg

clean-build:
	rm -rf build/

clean-out:
	rm -rf out/

newcover/fancyBook/template/fancyBook/loadOptions.sty: config/newcover_template_name
	. ./configuration ; envsubst <newcover/fancyBook/template/fancyBook/loadOptions.sty.tpl >newcover/fancyBook/template/fancyBook/loadOptions.sty


newcover/src/ukuleleVariables.sty: config/TAG config/TAG-songs newcover/src/ukuleleVariables.sty.tpl config/bookname 
	. ./configuration ; envsubst <newcover/src/ukuleleVariables.sty.tpl >newcover/src/ukuleleVariables.sty

newcover/src/guitarVariables.sty: config/TAG config/TAG-songs newcover/src/guitarVariables.sty.tpl config/bookname
	. ./configuration ; envsubst <newcover/src/guitarVariables.sty.tpl >newcover/src/guitarVariables.sty

newcover/ukulele.pdf: newcover/src/ukuleleVariables.sty newcover/ukulele.tex newcover/fancyBook/template/fancyBook/loadOptions.sty
	(cd newcover ; pdflatex --shell-escape ukulele.tex)

newcover/guitar.pdf: newcover/src/guitarVariables.sty newcover/guitar.tex newcover/fancyBook/template/fancyBook/loadOptions.sty
	(cd newcover ; pdflatex --shell-escape guitar.tex)

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

out/songbook-guitar.pdf: build/guitar/toc.pdf build/empty.pdf songs/*.chopro chordpro-guitar.json newcover/guitar.pdf
	./create_songbook.py guitar ukulele

build/ukulele/toc.txt:
	mkdir -p build/ukulele/ ; (cd songs ; find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro") | cut -c 3- | sed 's/\(-ukulele\)\{0,1\}\.chopro$$//' | sort > build/ukulele/toc.txt

build/ukulele/toc.ps: build/ukulele/toc.txt
	cat build/ukulele/toc.txt | iconv -c --from-code utf-8 --to-code ISO-8859-1 | enscript --margins=30::40: --encoding=88591 --font=Helvetica@12 --no-header --output=build/ukulele/toc.ps

build/ukulele/toc.pdf: build/ukulele/toc.ps
	ps2pdf build/ukulele/toc.ps build/ukulele/toc.pdf

out/songbook-ukulele.pdf: build/ukulele/toc.pdf build/empty.pdf songs/*.chopro chordpro-ukulele.json newcover/ukulele.pdf
	./create_songbook.py ukulele guitar

checksongs:
	./checksongs.py

release: clean quickrelease

quickrelease: config/COMMIT-HASH config/COMMIT-HASH-songs checksongs out/songbook-guitar.pdf out/songbook-ukulele.pdf out/songbook-guitar-printshop.pdf out/songbook-ukulele-printshop.pdf
	./release.py

release-offline: clean quickrelease-offline

quickrelease-offline: config/COMMIT-HASH config/COMMIT-HASH-songs checksongs out/songbook-guitar.pdf out/songbook-ukulele.pdf out/songbook-guitar-printshop.pdf out/songbook-ukulele-printshop.pdf
	./release.py --no-upload

build/ukulele.songlist: songs/*.chopro
	mkdir -p build ; ./create_songlist.py --instrument=ukulele > build/ukulele.songlist

build/guitar.songlist: songs/*.chopro
	mkdir -p build ; ./create_songlist.py --instrument=guitar > build/guitar.songlist

config/COMMIT-HASH: FORCE
	./update_commit_hashes.sh

config/COMMIT-HASH-songs: FORCE
	./update_commit_hashes.sh songs

config/TAG: FORCE
	./update_commit_hashes.sh

config/TAG-songs: FORCE
	./update_commit_hashes.sh songs

FORCE: