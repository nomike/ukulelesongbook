#!/usr/bin/env python3

import sys
import re

if __name__ == "__main__":
    verse_count = 1
    last_section = None
    re_section_header = re.compile('^\[([^\]]*)\]$')
    with open(sys.argv[1], 'r') as file:
        lines = file.readlines()
    for i in range(0, len(lines)):
        line = lines[i].rstrip('\n')
        match = re_section_header.match(line)
        if match:
            if last_section:
                print('{end_of_%s}\n' % (last_section.replace('-', '')))
            last_section = match.group(1).lower()
            print('{start_of_%s: %s}' % (last_section.replace('-', ''), "%s %d" % (last_section.capitalize(), verse_count) if last_section == 'verse' else last_section.capitalize()))
            if last_section == "verse":
                verse_count = verse_count + 1
        else:
            if not (len(line) == 0 and i < (len(lines) - 1) and lines[i+1].startswith("[")):
                print(line)
    if last_section:
        print('{end_of_%s}' % (last_section))

