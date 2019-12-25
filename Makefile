all: ukulele guitar
ukulele: songbook.pdf
guitar: songbook-guitar.pdf
cover-ukulele: cover-ukulele.pdf
cover-guitar: cover-guitar.pdf
songbook.pdf : *.chopro chordpro.json cover-ukulele.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro" -print0 | sort -z | xargs --null chordpro --output songbook.pdf --cover cover-ukulele.pdf

songbook-guitar.pdf : *.chopro chordpro-guitar.json cover-guitar.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-ukulele.chopro" -print0 | sort -z | xargs --null chordpro --config chordpro-guitar.json --output songbook-guitar.pdf --cover cover-guitar.pdf

clean:
	rm -f songbook.pdf songbook-guitar.pdf cover-guitar.pdf cover-guitar.aux cover-guitar.log cover-ukulele.pdf cover-ukulele.aux cover-ukulele.log

cover-ukulele.pdf: cover-ukulele.tex
	pdflatex cover-ukulele.tex ; rm -f cover-ukulele.aux cover-ukulele.log

cover-guitar.pdf: cover-guitar.tex
	pdflatex cover-guitar.tex ; rm -f cover-guitar.aux cover-guitar.log
