all: ukulele guitar
ukulele: songbook.pdf
guitar: songbook-guitar.pdf
songbook.pdf : *.chopro chordpro.json
	chordpro --output songbook.pdf *.chopro

songbook-guitar.pdf : *.chopro chordpro.json
	chordpro --config chordpro-guitar.json --output songbook-guitar.pdf *.chopro

clean:
	rm songbook.pdf songbook-guitar.pdf
