#!/usr/bin/env python3
"""
Usage:
    create_songbook.py --instrument=<instrument>
"""
import glob
import re
import subprocess
import os
from docopt import docopt

instruments = ['ukulele', 'guitar']

if __name__ == "__main__":
    arguments = docopt(__doc__, version='creae_songbook.py v. 0.1')
    if not arguments["--instrument"] in instruments:
        raise Exception("Unsupported instrument")
    target_instrument = arguments["--instrument"]
    excludeded_instruments = [re.compile('^.*-%s.chopro$' % (i)) for i in instruments if i != target_instrument]
    with open('%s-songlist' % (target_instrument), 'r') as file:
        lines = [os.path.join("songs", i.rstrip('\n')) for i in file.readlines()]

    filelist = glob.glob('songs/*.chopro')
    filelist.sort()
    for file in filelist:
        for p in excludeded_instruments:
            if not p.match(os.path.basename(file)):
                if not file in lines:
                    lines.append(file)
    command = ['/usr/local/bin/chordpro', '--config', 'chordpro-%s.json' % (target_instrument), '--output', 'songbook-%s.pdf' % (target_instrument), '--cover', 'cover/cover-%s.pdf' % (target_instrument)]
    command.extend(lines)
    subprocess.run(command)
