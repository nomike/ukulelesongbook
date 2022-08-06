#!/usr/bin/env python3
"""
Usage:
    generate_pront_string.py --instrument=<instrument> <song>...
"""

import re
import os
from docopt import docopt
import csv
import logging

instruments = ['ukulele', 'guitar', 'pinao']

class Break(Exception):
    pass

def generate_print_string(songs, instrument):
    print_string = ''
    if len(songs) == 0:
        return print_string
    pageinfo = {}
    with open(f'out/songbook-{instrument}-regular.csv', 'r') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';')
        for row in reader:
            key = f"{row['title']} - {row['artists']}".replace("’", "'").replace('/', '_')
            pageinfo[key] = row['pages']
    toc = [int(i) for i in pageinfo['__table_of_contents__ - ChordPro'].split('-')]
    print_string = print_string + '-'.join([str(toc[0]-1), str(toc[1]+1)])
    instrument_suffix = f'-{instrument}'
    ignore_instruments = [i for i in instruments if not i == instrument]
    for song in songs:
        try:
            for ignore_instrument in ignore_instruments:
                if song.endswith(f'-{ignore_instrument}'):
                    raise Break()
            if song.endswith(instrument_suffix):
                song = song[:-len(instrument_suffix)]
            if song in pageinfo:
                (start, end) = pageinfo[song].split('-')
                print_string = print_string + f',{int(start)-1}-{int(end)+1}'
        except Break: 
            pass
    return print_string

if __name__=="__main__":
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='generate_print_string.py v. 1.0')
    instrument = arguments["--instrument"]
    logging.debug("Selected instrument: %s" % instrument)
    songs = [x.replace(".chopro", "") for x in arguments["<song>"]]
    logging.debug("Selected songs: %s" % songs)
    print(generate_print_string(songs, instrument))
