#!/usr/bin/env python3
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
    return max(len(rxcountpages.findall(data)), 1)

def generate_print_string(songs, instrument):
    if not instrument in instruments:
        raise Exception("Unsupported instrument")
    if len(songs) == 0:
        return ""
    print_string = ""
    cover_pages = count_pdf_pages(os.path.join("build", instrument, "paged", "cover.pdf"))
    if cover_pages == 0:
        cover_pages = 1
    toc_pages = count_pdf_pages(os.path.join("build", instrument, "paged", "toc.pdf"))
    files = [os.path.basename(x) for x in glob("build/%s/paged/songs/*.pdf" % (instrument))]
    files.sort()
    all_songs = []
    for file in files:
        all_songs.append({"title": file, "pages": count_pdf_pages(("build/%s/paged/songs/" % (instrument)) + file)})
    current_page = cover_pages + toc_pages
    start = 1
    end = current_page - 1
    for song in all_songs:
        if song["title"].replace(".pdf", "") in songs:
            new_start = current_page
            new_end = current_page + song["pages"] + 1
            if new_start > end:
                print_string = print_string + "%d-%d," % (start, end)
                start = new_start
            end = new_end
        current_page = current_page + song["pages"]
    print_string = print_string + "%d-%d" % (start, end)
    return print_string

if __name__=="__main__":
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='generate_print_string.py v. 0.1')
    instrument = arguments["--instrument"]
    logging.debug("Selected instrument: %s" % instrument)
    songs = [x.replace(".chopro", "") for x in arguments["<song>"]]
    logging.debug("Selected songs: %s" % songs)
    print(generate_print_string(songs, instrument))
