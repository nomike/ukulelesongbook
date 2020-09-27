#!/usr/bin/env python3

import sys
import re

if __name__ == "__main__":
    verse_count = 1
    last_section = None
    re_section_header = re.compile('^\[([^\]]*)\]$')
    re_numbered = re.compile('^(.*) [0-9]*$')
    with open(sys.argv[1], 'r') as file:
        lines = [i.rstrip('\n') for i in file.readlines()]
    for i in range(0, len(lines)):
        line = lines[i]
        match = re_section_header.match(line)
        if match:
            if last_section:
                print('{end_of_%s}\n' % (last_section.replace('-', '')))
            match_numbered = re_numbered.match(match.group(1))
            if match_numbered:
                last_section = match_numbered.group(1).lower()
            else:
                last_section = match.group(1).lower()
            print('{start_of_%s: %s}' % (last_section.replace('-', ''), "%s %d" % (last_section.capitalize(), verse_count) if last_section == 'verse' else last_section.capitalize()))
            if last_section == "verse":
                verse_count = verse_count + 1
        else:
            if not (len(line) == 0 and i < (len(lines) - 1) and lines[i+1].startswith("[")):
                print(line)
    if last_section:
        print('{end_of_%s}' % (last_section))

