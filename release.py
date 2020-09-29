#!/usr/bin/env python3
"""
Usage:
    release.py [--no-upload] [-v]
"""

import json
import subprocess
import os
from generate_print_string import generate_print_string
import logging
from docopt import docopt

def calculate_print_string(instrument, start, end = 'HEAD'):
    logging.info("Calculate %s print string for tag %s" % (instrument, start))
    songs = str(subprocess.run(["git", "--no-pager", "diff", "--name-only", start, end], cwd = os.path.join(os.getcwd(), 'songs'), capture_output=True).stdout, 'utf-8').strip().split("\n")
    songs = [bytes(bytes(x.replace(".chopro", ""), 'ascii').decode('unicode-escape'), 'latin_1').decode('utf-8').strip('"') for x in songs if x]
    logging.debug("Songs to consider: %r" % (songs))
    print_string = generate_print_string(songs, instrument)
    logging.debug("Print string: %s" % (print_string))
    return print_string

def upload_file(file, target):
    logging.info("Upload file %s" % (file))
    result = subprocess.run(["scp", file, target], capture_output=True)
    if result.returncode != 0:
        raise IOError("Error uploading file %s to target %s: %s" % (file, target, str(result.stderr, 'utf-8')))

if __name__ == "__main__":
    arguments = docopt(__doc__, version='release.py v. 0.2')
    if arguments['-v']:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)
        
    releases = None
    logging.info("Get current release file.")
    if os.path.isfile('config/releases.json'):
        with open('config/releases.json', 'r') as file: 
            releases = json.load(file)
    if releases == None:
        logging.info("The releases list is empty or the file does not exist yet. Initialize it with defaults.")
        releases = {}
        releases['songs_tags'] = []
        releases['print_strings'] = {}

    with open('config/TAG-songs', 'r') as file:
        current_songs_tag = file.readlines(1)[0].strip()
    logging.info("Current songs tag: %s" % (current_songs_tag))
    
    with open('config/upload_target', 'r') as file:
        upload_target = file.readlines(1)[0].strip()
    logging.info("Upload target: %s" % (upload_target))
    
    tags = releases['songs_tags']
    # if the current tag is not yet in the releases list add it
    if not current_songs_tag in tags:
        logging.info("Add new release to releases.")
        releases['songs_tags'].append(current_songs_tag)

    # (re-)calculate the print strings between all releases and the current release, and add them to the config
    for tag in tags:
        logging.info("Calculate print strings for release %s" % (tag))
        print_string_guitar = calculate_print_string('guitar', tag, current_songs_tag)
        print_string_ukulele = calculate_print_string('ukulele', tag, current_songs_tag)
        releases['print_strings'][tag] = {'ukulele': print_string_ukulele, 'guitar': print_string_guitar}

    logging.info("Dump the release info into the releases file.")
    with open('config/releases.json', 'w') as file: 
        json.dump(releases, file, indent=4, sort_keys=True)
    
    if not arguments['--no-upload']:
        logging.info("Upload files to %s." % (upload_target))
        upload_file('out/songbook-guitar.pdf', upload_target)
        upload_file('out/songbook-guitar-printshop.pdf', upload_target)
        upload_file('out/songbook-ukulele.pdf', upload_target)
        upload_file('out/songbook-ukulele-printshop.pdf', upload_target)
        upload_file('config/releases.json', upload_target)
    