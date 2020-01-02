all: ukulele guitar
ukulele: songbook-ukulele.pdf
guitar: songbook-guitar.pdf
cover-ukulele: cover-ukulele.pdf
cover-guitar: cover-guitar.pdf
songbook-ukulele.pdf : *.chopro chordpro-ukulele.json cover-ukulele.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro" -print0 | sort -z | xargs --null chordpro --config chordpro-ukulele.json --output songbook-ukulele.pdf --cover cover-ukulele.pdf

songbook-guitar.pdf : *.chopro chordpro-guitar.json cover-guitar.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-ukulele.chopro" -print0 | sort -z | xargs --null chordpro --config chordpro-guitar.json --output songbook-guitar.pdf --cover cover-guitar.pdf

clean:
	rm -f songbook-ukulele.pdf songbook-guitar.pdf cover-guitar.pdf cover-guitar.aux cover-guitar.log cover-ukulele.pdf cover-ukulele.aux cover-ukulele.log

cover-ukulele.tex: cover-ukulele.tex.tpl configuration
	. ./configuration ; export nusb_version ; envsubst <cover-ukulele.tex.tpl >cover-ukulele.tex

cover-guitar.tex: cover-guitar.tex.tpl configuration
	. ./configuration ; export nusb_version ; envsubst <cover-guitar.tex.tpl >cover-guitar.tex

cover-ukulele.pdf: cover-ukulele.tex
	pdflatex cover-ukulele.tex ; rm -f cover-ukulele.aux cover-ukulele.log

cover-guitar.pdf: cover-guitar.tex
	pdflatex cover-guitar.tex ; rm -f cover-guitar.aux cover-guitar.log

clean-vscode: clean
	rm -f cover-guitar.aux cover-guitar.fdb_latexmk cover-guitar.fls cover-guitar.log cover-guitar.synctex.gz cover-ukulele.aux cover-ukulele.fdb_latexmk cover-ukulele.fls cover-ukulele.log cover-ukulele.synctex.gz

convert-tabs:
	for i in *.tab ; do chordpro --a2crd "$${i}" > "$${i%.tab}.chopro" ; rm -f "$${i}" ; done
