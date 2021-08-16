# Songs versioning
The songs folder has to be a git repository.
git tags are used to mark specific versions of the songbook. These tags are used
to calculate differences between versions to enable printing of incremental
updates.

 If you add or correct songs, it is recommended to create a git tag before
 releasing the new version.

 You can either define your own tags (using `git tag`) or use this convenient
 versionbump script:
```
git tag -a "$(../versionbump.py 2)"
```

## versionbump.py
This is a simple toll which sorts the current tags by a common version sort
algorithm and increments the specified part of the version numner.

Examples:
```
versionbump.py 0 # 1.2.3 --> 2.0.0
versionbump.py 2 # 3.0.9 --> 3.0.10
```

The songs version is printed on the inner cover page.
Additionally the version is added to the file `config/releases.json` and
print-strings are calculated between the current version and all previous
versions (more on print-strings below).

***Note:** This file is also uploaded via SCP when using the "release" target.*

# print-strings
When making a new release, the file `config/releases.json` is updated with
print-strings which allow you to update a physical printout of the songbook to
the newest version.
