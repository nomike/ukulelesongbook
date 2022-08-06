SHELL := /bin/bash -O nullglob
all: regular printshop
.PHONY: all printshop regular cover-ukulele cover-guitar cover-pinao clean clean-vscode clean-build clean-out convert convert-tabs convert-ultimate ukulele piano guitar
printshop: out/songbook-ukulele-printshop.pdf out/songbook-piano-printshop.pdf out/songbook-guitar-printshop.pdf
regular: out/songbook-guitar-regular.pdf out/songbook-piano-regular.pdf out/songbook-ukulele-regular.pdf
cover-ukulele: newcover/ukulele.pdf
cover-piano: newcover/piano.pdf
cover-guitar: newcover/guitar.pdf

out/songbook-ukulele-printshop.pdf: songs/*.chopro chordpro.json ukulele.json printshop.json newcover/ukulele.pdf
	./create_songbook.py --instrument ukulele --variant=printshop

out/songbook-piano-printshop.pdf: songs/*.chopro chordpro.json piano.json printshop.json newcover/piano.pdf
	./create_songbook.py --instrument piano --variant=printshop

out/songbook-guitar-printshop.pdf: songs/*.chopro chordpro.json guitar.json printshop.json newcover/guitar.pdf
	./create_songbook.py --instrument guitar --variant=printshop

clean: clean-newcover clean-build clean-out

clean-newcover:
	rm -f newcover/src/ukuleleVariables.sty newcover/src/pianoVariables.sty newcover/src/guitarVariables.sty newcover/*.aux newcover/*.fdb_latexmk newcover/*.fls newcover/*.idx newcover/*.log newcover/*.out newcover/*.pdf newcover/*.ilg

clean-build:
	rm -rf build/

clean-out:
	rm -rf out/

newcover/fancyBook/template/fancyBook/loadOptions.sty: config/newcover_theme_name
	. ./configuration ; envsubst <newcover/fancyBook/template/fancyBook/loadOptions.sty.tpl >newcover/fancyBook/template/fancyBook/loadOptions.sty

newcover/src/ukuleleVariables.sty: config/TAG config/TAG-songs newcover/src/ukuleleVariables.sty.tpl config/bookname
	. ./configuration ; envsubst <newcover/src/ukuleleVariables.sty.tpl >newcover/src/ukuleleVariables.sty

newcover/src/pianoVariables.sty: config/TAG config/TAG-songs newcover/src/pianoVariables.sty.tpl config/bookname
	. ./configuration ; envsubst <newcover/src/pianoVariables.sty.tpl >newcover/src/pianoVariables.sty

newcover/src/guitarVariables.sty: config/TAG config/TAG-songs newcover/src/guitarVariables.sty.tpl config/bookname
	. ./configuration ; envsubst <newcover/src/guitarVariables.sty.tpl >newcover/src/guitarVariables.sty

newcover/ukulele.pdf: newcover/chapters/usage.tex newcover/src/ukuleleVariables.sty newcover/ukulele.tex newcover/fancyBook/template/fancyBook/loadOptions.sty
	(cd newcover ; pdflatex --shell-escape ukulele.tex)

newcover/piano.pdf: newcover/chapters/usage.tex newcover/src/pianoVariables.sty newcover/piano.tex newcover/fancyBook/template/fancyBook/loadOptions.sty
	(cd newcover ; pdflatex --shell-escape piano.tex)

newcover/guitar.pdf: newcover/chapters/usage.tex newcover/src/guitarVariables.sty newcover/guitar.tex newcover/fancyBook/template/fancyBook/loadOptions.sty
	(cd newcover ; pdflatex --shell-escape guitar.tex)

convert: convert-ultimate convert-tabs

convert-tabs:
	( shopt -s nullglob; for i in songs/*.tab ; do chordpro --a2crd "$${i}" | grep -v "LYRICS" | grep -v "is not a valid chord." > "$${i%.tab}.chopro" ; rm -f "$${i}" ; done )

convert-ultimate:
	( shopt -s nullglob; for i in songs/*.ult ; do ./convert_ultimate.py "$${i}" > "$${i%.ult}.tab" ; rm -f "$${i}" ; done )

out/songbook-guitar-regular.pdf: songs/*.chopro chordpro.json guitar.json regular.json newcover/guitar.pdf
	./create_songbook.py --instrument guitar --variant=regular

out/songbook-piano-regular.pdf: songs/*.chopro chordpro.json piano.json regular.json newcover/piano.pdf
	./create_songbook.py --instrument=piano --variant=regular

out/songbook-ukulele-regular.pdf: songs/*.chopro chordpro.json ukulele.json regular.json newcover/ukulele.pdf
	./create_songbook.py --instrument ukulele --variant=regular

checksongs:
	./checksongs.py

check-song-commits:
	test 0 -eq $$(cd songs; ( git status --porcelain=v1 | wc -l ) )

check-script-commits:
	test 0 -eq $$(git status --porcelain=v1 | wc -l)

release: clean quickrelease

quickrelease: check-song-commits check-script-commits config/COMMIT-HASH config/COMMIT-HASH-songs checksongs out/songbook-guitar-regular.pdf  out/songbook-piano-regular.pdf out/songbook-ukulele-regular.pdf out/songbook-guitar-printshop.pdf  out/songbook-piano-printshop.pdf out/songbook-ukulele-printshop.pdf
	./release.py

release-offline: clean quickrelease-offline

quickrelease-offline: config/COMMIT-HASH config/COMMIT-HASH-songs checksongs out/songbook-guitar-regular.pdf out/songbook-piano-regular.pdf out/songbook-ukulele-regular.pdf out/songbook-guitar-printshop.pdf  out/songbook-piano-printshop.pdf out/songbook-ukulele-printshop.pdf
	./release.py --no-upload

config/COMMIT-HASH: FORCE
	./update_commit_hashes.sh

config/COMMIT-HASH-songs: FORCE
	./update_commit_hashes.sh songs

config/TAG: FORCE
	./update_commit_hashes.sh

config/TAG-songs: FORCE
	./update_commit_hashes.sh songs

FORCE: