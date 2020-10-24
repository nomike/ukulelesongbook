#!/usr/bin/env python3

import glob
import os
import re
import sys

def rchop(s, suffix):
    if suffix and s.endswith(suffix):
        return s[:-len(suffix)]
    return s

if __name__ == "__main__":

    issue = False
    for (s, a) in [f[:-7].split(" - ") for f in glob.glob('songs/*.chopro')]:
        filename = '%s - %s.chopro' % (s, a)
        with open(filename, 'r') as file:
            content = file.read()
            song = os.path.basename(s)
            artist = rchop(rchop(a, '-ukulele'), '-guitar')
            
            if not re.search("{t(?:itle)?: ?%s}" % song.replace("(", "\\(").replace(")", "\\)"), content.replace('/', '_')):
                issue = True
                print("Wrong title in song '%s'" % (filename))
            if not re.search("{artist: ?%s}" % artist.replace("(", "\\(").replace(")", "\\)"), content.replace('/', '_')):
                issue = True
                print("Wrong artist in song '%s'" % (filename))
    if issue:
        sys.exit(1)
    else:
        sys.exit(0)