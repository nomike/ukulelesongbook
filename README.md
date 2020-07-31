nomike's Ukulele Songbook
=========================
This repository contains chordpro files and scripts to re-create nomike's ukulele Songbook. It is not to be published publicly due to copyright reasons but might be handed around on a fair use basis for private use.
The song book comes in a ukulele and a guitar flavour. The main difference is that the guitar flavour uses guitar-chord-diagrams for standard tuning (EADGBE) whereas the ukulele flavour uses chord diagrams specific to the ukulele standard tuning (GCEA). But it is also possible to specify songs or versions of them to appear only in one of the editions. See below for details.

Dependencies
------------
You need to install a couple of dependencies:

### Additional packages
#### Ubuntu/Debian
```
sudo apt install texlive-full python3-docopt enscript libpdf-api2-perl imagemagick libstring-interpolate-perl
sudo cpan install App::Packager
sudo cpan install chordpro
```
<!-- TODO: Add instructions for other operating systems** -->

### Imagemagick
You need to enable PDF support for ImageMagick.<br/>
Edit the file `/etc/ImageMagick-6/policy.xml`
and change line
```
<policy domain="coder" rights="none" pattern="PDF" />
```
to
```
<policy domain="coder" rights="read | write" pattern="PDF" />
```


building the songbook
---------------------
If you want to build the songbook just execute the included Makefile:
```
$ make
```

There are also targets for specifically building just the guitar or ukulele versions of the songbook:
```
$ make ukulele
$ make guitar
```

Adding songs to the songbook
----------------------------
If you want to add a song, just place the corresponding chordpro file with a ".chopro" extension in the songs folder and build the songbook.

Songs specific to one edition
-----------------------------
If a song's filename matches the shell glob `*-ukulele.chopro` it is only included in the ukulele edition. Similar logic exist for `*-guitar.chopro`. This is especially usefull for songs with tabs, which look different for guitat and ukulele.

Converting chord-above-text files
---------------------------------
If you want to convert a song from the common chord above text format (see example below) to chordpro, you can use the "convert-tabs" Makefile target:
```
$ make convert-tabs
```
This will convert all *.tab files in the current folder to the chordpro format and save them with a .chopro extension. The source files will be deleted after conversion.

A chord over text file looks something like this:
```
        D        G      D
Swing low, sweet chariot,
                       A7
Comin' for to carry me home.
       D7        G      D
Swing low, sweet chariot,
               A7       D
Comin' for to carry me home.
```

Converting Ultimate Guitar files
--------------------------------
Files originating from https://ultimate-guitar.com can be converted with the `convert-ultimate` Makefile target. All files with an `.ult` file extension in the songs directoy will be converted to the chord-above-text format mentioned above and can be converted to chordpro by executing the `convert-tabs` Makefile target as outlined above.
The sorce files will be deleted after being converted.

### Format
This Format is an extension of the chord-above-text format described above. The extension is, that sections like the chorus, bridges, etc. can be marked with putting them in bracketes:
```
[Chorus]
Gm       F        C      Cm
Put your Hands up in the air!

[Verse]
A     G     Csus2
On an empty dancefloor
```

Versese which are just labled `Verse`, will automatically be numbered.

***Note**: This conversion is not very robust. Expect some weird results and adapt the source files or fix the resulting output accordingly.*

## Ultimate Guitar format with square brackets
If the file looks like this:
```
[Intro]
[ch]Am[/ch] - [ch]F[/ch] - [ch]C[/ch] - [ch]G[/ch]

[Chorus]
[tab][ch]Am[/ch]        [ch]F[/ch]              [ch]C[/ch]
 How long, how long will I slide?[/tab]
```

You can clean up the mess with search and replace, using the following regular expression to replace the matches with nothing:
```
\[/?(tab|ch)\]
```

It can then be treated like any other ultimate guitar file.

Single songbooks
----------------
Single songbooks are printable versions of the songbook where songs can be added easily.
An individual PDF is generated for each song and the reulting files are joined together with the cover and a freshly generated TOC.
If new songs are added, just print the new songs and sort put them into the existing book.

empty.pdf
---------
Contains an empty A4 page to be spliced into a PDF.
Can be created with imagemagic:
```
$ convert xc:none -page A4 empty.pdf
```

clean-vscode
------------
If you use visual studio code for editing the latex sources used for the cover pages, the LATEX plugin will create some aditional temporary files which can be cleaned up with the "clean-vcsode" target of the Makefile:
`make clean-vscode`
