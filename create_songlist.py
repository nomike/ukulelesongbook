#!/usr/bin/env python3
"""
Usage:
    create_songlist.py --instrument=<instrument>
"""

import re
import os
from docopt import docopt
import logging
from glob import glob

instruments = ['ukulele', 'guitar']


rxcountpages = re.compile(b"/Type\s*/Page([^s]|$)", re.MULTILINE|re.DOTALL)

class restart(Exception):
    pass

def count_pdf_pages(filename):
    with open(filename, "rb") as file:
        data = file.read()
    return len(rxcountpages.findall(data))

if __name__=="__main__":
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='creae_songlist.py v. 0.1')
    if not arguments["--instrument"] in instruments:
        raise Exception("Unsupported instrument")
    target_instrument = arguments["--instrument"]
    songs = []
    files = [os.path.basename(x) for x in glob("build/%s/songs/*.pdf" % (target_instrument))]
    files.sort()
    for file in files:
        songs.append({"title": file, "pages": count_pdf_pages(("build/%s/songs/" % (target_instrument)) + file)})
    sorted_songs = []
    while len(songs) > 0:
        try:
            song = songs[0]
            sorted_songs.append(song)
            songs.remove(song)
            if song["pages"] % 2 == 0:
                raise restart()
            else:
                for song in songs:
                    if song["pages"] % 2 == 1:
                        sorted_songs.append(song)
                        songs.remove(song)
                        raise restart()
        except restart:
            pass

    for song in sorted_songs:
        print (song["title"].replace(".pdf", ".chopro"))