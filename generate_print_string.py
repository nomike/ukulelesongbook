#!/usr/bin/env
"""
Usage:
    generate_pront_string.py --instrument=<instrument> <song>...
"""

import re
import os
from docopt import docopt
import logging
from glob import glob

instruments = ['ukulele', 'guitar']

rxcountpages = re.compile(b"/Type\s*/Page([^s]|$)", re.MULTILINE|re.DOTALL)

def count_pdf_pages(filename):
    with open(filename, "rb") as file:
        data = file.read()
    return len(rxcountpages.findall(data))

if __name__=="__main__":
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='creae_songlist.py v. 0.1')
    if not arguments["--instrument"] in instruments:
        raise Exception("Unsupported instrument")
    instrument = arguments["--instrument"]
    if len(arguments["<song>"]) == 0:
        raise Exception("No songs specified to print")
    songs = [x.replace(".chopro", "") for x in arguments["<song>"]]

    cover_pages = count_pdf_pages(os.path.join("build", instrument, "paged", "cover.pdf"))
    cover_pages = 1
    toc_pages = count_pdf_pages(os.path.join("build", instrument, "paged", "toc.pdf"))
    files = [os.path.basename(x) for x in glob("build/%s/paged/songs/*.pdf" % (instrument))]
    files.sort()
    all_songs = []
    for file in files:
        all_songs.append({"title": file, "pages": count_pdf_pages(("build/%s/paged/songs/" % (instrument)) + file)})
    current_page = cover_pages + toc_pages
    for song in all_songs:
        if song["title"].replace(".pdf", "") in songs:
            print ("%d-%d," % (current_page, current_page + song["pages"] + 1), end="")
        current_page = current_page + song["pages"]
