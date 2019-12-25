all: ukulele guitar
ukulele: songbook.pdf
guitar: songbook-guitar.pdf
songbook.pdf : *.chopro chordpro.json cover-ukulele.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-guitar.chopro" -print0 | sort -z | xargs --null chordpro --output songbook.pdf --cover cover-ukulele.pdf

songbook-guitar.pdf : *.chopro chordpro-guitar.json cover-guitar.pdf
	find . -type f -a -name "*.chopro" -a ! -name "*-ukulele.chopro" -print0 | sort -z | xargs --null chordpro --config chordpro-guitar.json --output songbook-guitar.pdf --cover cover-guitar.pdf

clean:
	rm -f songbook.pdf songbook-guitar.pdf
