Building the songbook
---------------------
If you want to build the songbook just execute the default target of the
included `Makefile`:
```
$ make
```

There are also targets for specifically building just the guitar or ukulele
versions of the songbook:
```
$ make ukulele
$ make guitar
```

***Note:** It is intended to not run the python and shell scripts directly. You
should use the Makefile targets for all actions. The Makefile contains some
sanity checks and takes care that all necessary dependencies are met.*