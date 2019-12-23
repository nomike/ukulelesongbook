all: ukulele guitar
ukulele: songbook.pdf
guitar: songbook-guitar.pdf
songbook.pdf : *.chopro chordpro.json cover-ukulele.pdf
	chordpro --output songbook.pdf --cover cover-ukulele.pdf *.chopro

songbook-guitar.pdf : *.chopro chordpro.json cover-guitar.pdf
	chordpro --config chordpro-guitar.json --output songbook-guitar.pdf --cover cover-guitar.pdf *.chopro

clean:
	rm songbook.pdf songbook-guitar.pdf
