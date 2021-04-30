nomike's Ukulele Songbook
=========================

This repository contains scripts to create nomike's ukulele Songbook.

The song book comes in an ukulele and a guitar flavour. The main difference is that the guitar flavour uses guitar-chord-diagrams for standard tuning (EADGBE) whereas the ukulele flavour uses chord diagrams specific to the ukulele standard tuning (GCEA).
It is also possible to specify songs or versions of them to appear only in one of the editions. See below for details.

Dependencies
------------
You need to install a couple of dependencies:

### Additional packages
#### Ubuntu/Debian
```
sudo apt install texlive-full python3-docopt enscript libpdf-api2-perl imagemagick libstring-interpolate-perl python3-pypdf2
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

Building the songbook
---------------------
If you want to build the songbook just execute the default target of the included `Makefile`:
```
$ make
```

There are also targets for specifically building just the guitar or ukulele versions of the songbook:
```
$ make ukulele
$ make guitar
```

***Note:** It is intended to not run the python and shell scripts directly. You should use the Makefile targets for all actions. The Makefile contains some sanity checks and takes care that all necessary dependencies are met.*

The `songs` folder
------------------
All songs are to be placed in the `songs` folder in .chordpro format. `songs` is a symlink pointing to `../songs/`. as the songs have been split up to a separate repository due to copyright reasons.

***Note:** For some features to work, the `songs` folder needs to be a git repository.*

Adding songs to the songbook
----------------------------
If you want to add a song, just place the corresponding chordpro file with a `.chopro` extension in the `songs` folder and build the songbook.

Songs specific to one edition
-----------------------------
If a song's filename matches the shell glob `*-ukulele.chopro` it is only included in the ukulele edition. Similar logic exist for `*-guitar.chopro`. This is especially usefull for songs with tabs, which look different for guitar and ukulele.

Converting chord-above-text files
---------------------------------
If you want to convert a song from the common chord above text format (see example below) to chordpro, you can use the `convert-tabs` Makefile target:
```
$ make convert-tabs
```
This will convert all `*.tab` files in the `songs` folder to the chordpro format and save them with a `.chopro` extension. The source files will be deleted after conversion.

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
Files originating from https://ultimate-guitar.com can be converted with the `convert-ultimate` Makefile target. All files with an `.ult` file extension in the `songs` directoy will be converted to the chord-above-text format mentioned above and can be converted to chordpro by executing the `convert-tabs` Makefile target as outlined above.
The source files will be deleted after being converted.

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

Song versioning
---------------
The songs folder needs to be a git repository. If you add or correct songs, it is recommended to create a git tag before releasing the new version. Go to the songs folder and do this:

```
git tag -a '1.4.0'
```

The songs version is printed on the inner cover page.
Additionally the version is added to the file `config/releases.json` and print-strings are generated between the current version and all past versions (more on print-strings below).
***Note:** This file is also uploaded via SCP when using the "release" target.*

print-strings
-------------
When making a new release, the file `config/releases.json` is updated with print-strings which allow you to update a physical printout of the songbook to the newest version.

Updating your songbook
----------------------
To print the update, lookup the songs version printed on the inner cover page of your physical printout in the file `config/releases.json`. There you'll find the print-strings for getting the guitar or ukulele edition up to date.

Open the PDF in your favourite PDF viewer, go to the print dialog, select the option to only print certain pages and copy/paste the print string from the file `config/releases.json` file into the field for specifing which pages to print.
***Note:** While I dont' own a mac to confirm this, it looks like there is no such option in macos's preview app. If you know how to do this in macos, please let me know. In Linux/Ubuntu/Gnome and Windows an option like that is right there*

Merging your songbook with the update
-------------------------------------
Merging the update takes little practice. I figured out this simple algorithm that always works:


To prepare, remove the book rings from your songbook and put it on the table in front of you (the todo-pile).
Punch holes in the update-pages and put them face up on a pile to the right of your songbook (the update pile).
You will create two more piles on the left. One for the sorted out pages (which you throw away at the end so I'll call it the burn pile) and one for the updated songbook (the done pile).

So at the end you have these piles:

[A] [B] [C] [D]

A = Burn pile (face down)  
B = Done pile (face down)  
C = Todo pile (face up)  
D = Update pile (face up)  

The steps for the upgrade:

Compare the top page on piles C and D.

***Note:** The algorithm requires you to compare pages. This is done by comparing the sort order (songtitle/artist). Of course there could be minor differences in the page's contents, it's an update after all. But if the sort order is the same, the pages are considered to be the same.*

***Hint:** If you have two empty pages to compare, look at their backsides.*

If the pages on the todo and update pile have the same sort order, move the page from the todo pile to the burn pile and the page from the update pile to the done pile.

If the pages don't have the same sort order, move the page which comes first to the done pile.

Repeat this until the todo and update stacks are empty.

Then you could put back the book-rings and throw away the pages from the burn stack.

If you feel more comfortable reading this as pseudocode, here you are:

```
while len(todo) > 0 or len(update) > 0:
  if todo[0].sortorder == update[0].sortorder:
    move todo[0] -> burn
    move update[0] -> done
  if todo[0].sortorder < update[0].sortorder:
    move todo[0] -> done
  if update[0].sortorder < todo[0].sortorder:
    move update[0] -> done
```

Printshop songbooks
-------------------
The printshop versions of the songbooks can not be updated with the method above.
