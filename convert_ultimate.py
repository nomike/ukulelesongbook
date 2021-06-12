#!/usr/bin/env python3
"""
Ultimate Converter - Converts tabs from a popular tab website to an intermediate format parseable by `chordpro a2crd`.

Usage:
    convert_ultimate.py <path_to_song>

The result is printed to stdout.
"""


import sys
import re
import os

if __name__ == "__main__":
    verse_count = 1
    last_section = None
    re_section_header = re.compile('^\[([^\]]*)\]$')
    re_numbered = re.compile('^(.*) [0-9]*$')
    re_repeat = re.compile('^(.*)(x[0-9]{1,2})$')
    with open(sys.argv[1], 'r') as file:
        lines = [i.rstrip('\n') for i in file.readlines()]
    (song, artist) = os.path.basename(sys.argv[1])[:-4].split(" - ")
    print("{t: %s}" % (song))
    print("{artist: %s}" % (artist))
    unskip_empty_line = True
    was_empty_line = False
    for i in range(0, len(lines)):
        line = lines[i].rstrip()
        match = re_section_header.match(line)
        if was_empty_line and unskip_empty_line and not match:
            unskip_empty_line = False
            print("")

        if len(line) == 0:
            # this line is empty
            was_empty_line = True
            continue
        else:
            was_empty_line = False
            unskip_empty_line = True

        if match:
            # this line is a section header
            unskip_empty_line = False
            if last_section:
                print('{end_of_%s}\n' % (last_section.replace('-', '').replace(' ', '_')))
            match_numbered = re_numbered.match(match.group(1))
            if match_numbered:
                last_section = match_numbered.group(1).lower()
            else:
                last_section = match.group(1).lower()
            print('{start_of_%s: %s}' % (last_section.replace('-', '').replace(' ', '_'), "%s %d" % (last_section.capitalize(), verse_count) if last_section == 'verse' else last_section.capitalize()))
            if last_section == "verse":
                verse_count = verse_count + 1
        else:
            # this line is a normal line
            match = re_repeat.match(line)
            if match:
                print(match[1].rstrip())
                print(f'{{c: {match[2]}}}')
            else:
                if not (len(line) == 0 and i < (len(lines) - 1) and lines[i+1].startswith("[")):
                    print(line)
    if last_section:
        print('{end_of_%s}' % (last_section))

