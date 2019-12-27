nomike's Ukulele Songbook
=========================
This repository contains chordpro files and scripts to re-create nomike's ukulele Songbook. It is not to be published publicly due to copyright reasons but might be handed around on a fair use basis for private use.
The song book comes in a ukulele and a guitar flavour. The main difference is that the guitar flavour uses guitar-chord-diagrams for standard tuning (EADGHE) whereas the ukulele flavour uses chord diagrams specific to the ukulele standard tuning (GCEA). But it is also possible to specify songs or versions of them to appear only in one of the editions. See below for details.

dependencies
------------
The songbook depends on [chordpro][1] and [latex][2].

Chordpro can be installed with cpan on all platforms:
`$ cpan install chordpro`

For LATEX either texlive (linux) or mikex (windows) are recommended.

Linux: `$ sudo apt install texlife-full` or `$ sudo yum install texlive-full`
Windows: Download and install miktex, or use the chcolatey package manager: `choco install miktex`

building the songbook
---------------------
If you want to build the songbook just execute the included Makefile:
`make`

There is also targets for specifically building the guitar or ukulele versions of the songbook:
`make ukulele`
`make guitar`

Adding songs to the songbook
----------------------------
If you want to add a song, just place the corresponding chordpro file with a ".chopro" extension in this folder and build the songbook.

Songs specific to one edition
-----------------------------
If a song's filename matches the shell glob "*-ukulele.chopro" it is only included in the ukulele edition. Similar logic exist for "*-guitar.chopro". This is especially usefull for songs with tabs, which look different for guitat and ukulele.

Converting chord-above-text files
---------------------------------
If you want to convert a song from the common chord above text format (see example below) to chordpro, you can use the "convert-tabs" Makefile target.
`make convert-tabs`
This will convert all *.tab files in the current folder to the chordpro format and save them with a .chopro extension. The source files will be deleted after conversion.

A chord over text file will look something like this:
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

clean-vscode
------------
If you use visual studio code for editing the latex sources used for the cover pages, the LATEX plugin will create some aditional temporary files which can be cleaned up with the "clean-vcsode" target of the Makefile:
`make clean-vscode`
