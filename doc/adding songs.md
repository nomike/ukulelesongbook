# The `songs` folder

The `songs` folder is not part of this git repository.
It has to be it's own git repo.

Songs should be added to this folder as ChordPro files with a `.chopro` file
extension.

# Songs specific to one edition
If a song's filename matches the shell glob `*-ukulele.chopro` it is only
included in the ukulele edition. Similar logic exist for `*-guitar.chopro`.
This is especially usefull for songs with tabs, which look different for guitar
and ukulele.

# Converting chord-above-text files
If you want to convert a song from the common chord above text format (see
example below) to chordpro, you can use the `convert-tabs` Makefile target:
```
$ make convert-tabs
```
This will convert all `*.tab` files in the `songs` folder to the chordpro format
and save them with a `.chopro` extension. The source files will be deleted after
conversion.

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

# Converting Ultimate Guitar files
Files originating from https://ultimate-guitar.com can be converted with the
`convert-ultimate` Makefile target. All files with an `.ult` file extension in
the `songs` directoy will be converted to the chord-above-text format mentioned
above and can be converted to chordpro by executing the `convert-tabs`
Makefile target as outlined above.
The source files will be deleted after being converted.

### Format
This Format is an extension of the chord-above-text format described above. The
extension is, that sections like the chorus, bridges, etc. can be marked with
putting them in square-brackets:
```
[Chorus]
Gm       F        C      Cm
Put your Hands up in the air!

[Verse]
A     G     Csus2
On an empty dancefloor
```

Versese which are just labled `Verse`, will automatically be numbered.

***Note**: Songs from ultimete-guitar are mostly provided by the comminity and
don't always follow consistent formatting. Be sure to check the produced
`.chopro` files and fix errors you see.*

## Ultimate Guitar format with square brackets
If the file looks like this:
```
[Intro]
[ch]Am[/ch] - [ch]F[/ch] - [ch]C[/ch] - [ch]G[/ch]

[Chorus]
[tab][ch]Am[/ch]        [ch]F[/ch]              [ch]C[/ch]
 How long, how long will I slide?[/tab]
```

You can clean up the mess with search and replace, using the following regular
expression to replace the matches with nothing:
```
\[/?(tab|ch)\]
```

It can then be treated like any other ultimate guitar file.
