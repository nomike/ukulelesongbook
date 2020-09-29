#!/usr/bin/env python3

import json
import subprocess
import os
from generate_print_string import generate_print_string

def calculate_print_string(instrument, start, end = 'HEAD'):
    songs = str(subprocess.run(["git", "--no-pager", "diff", "--name-only", start, end], cwd = os.path.join(os.getcwd(), 'songs'), capture_output=True).stdout, 'utf-8').strip().split("\n")
    songs = [bytes(bytes(x.replace(".chopro", ""), 'ascii').decode('unicode-escape'), 'latin_1').decode('utf-8').strip('"') for x in songs if x]
    print_string = generate_print_string(songs, instrument)
    return print_string

def upload_file(file, target):
    result = subprocess.run(["scp", file, target], capture_output=True)
    if result.returncode != 0:
        raise IOError("Error uploading file %s to target %s: %s" % (file, target, str(result.stderr, 'utf-8')))

if __name__ == "__main__":
    # get current release list
    releases = None
    if os.path.isfile('config/releases.json'):
        with open('config/releases.json', 'r') as file: 
            releases = json.load(file)
    if releases == None:
        # current release list is empty or the file does not yet exist, initialize it with empty defaults
        releases = {}
        releases['songs_tags'] = []
        releases['print_strings'] = {}

    # get the current tag
    with open('config/TAG-songs', 'r') as file:
        current_songs_tag = file.readlines(1)[0].strip()

    # get the upload target
    with open('config/upload_target', 'r') as file:
        upload_target = file.readlines(1)[0].strip()
    
    tags = releases['songs_tags']

    # if the current tag is not yet in the releases list add it
    if not current_songs_tag in tags:
        releases['songs_tags'].append(current_songs_tag)

    # (re-)calculate the print strings between all releases and the current release, and add them to the config
    for tag in tags:
        print_string_guitar = calculate_print_string('guitar', tag, current_songs_tag)
        print_string_ukulele = calculate_print_string('ukulele', tag, current_songs_tag)
        releases['print_strings'][tag] = {'ukulele': print_string_ukulele, 'guitar': print_string_guitar}

    # dump the config to the json file again
    with open('config/releases.json', 'w') as file: 
        json.dump(releases, file, indent=4, sort_keys=True)

    # upload songbooks and releases file
    # upload_file('out/songbook-guitar.pdf', upload_target)
    # upload_file('out/songbook-guitar-printshop.pdf', upload_target)
    # upload_file('out/songbook-ukulele.pdf', upload_target)
    # upload_file('out/songbook-ukulele-printshop.pdf', upload_target)
    # upload_file('config/releases.json', upload_target)
    