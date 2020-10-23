#!/usr/bin/env python3
"""
Usage:
    create_printshop_songbook.py --instrument=<instrument>
"""
import glob
import re
import subprocess
import os
from docopt import docopt
import logging
import locale
locale.setlocale(locale.LC_ALL, '')

instruments = ['ukulele', 'guitar']

if __name__ == "__main__":
    os.makedirs("out", exist_ok=True)
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='creae_songbook.py v. 0.1')
    if not arguments["--instrument"] in instruments:
        raise Exception("Unsupported instrument")
    target_instrument = arguments["--instrument"]
    excluded_instruments = [re.compile('^.*-%s.chopro$' % (i)) for i in instruments if i != target_instrument]
    with open('build/%s.songlist' % (target_instrument), 'r') as file:
        lines = [os.path.join("songs", i.rstrip('\n')) for i in file.readlines() if i[0] != "#"]

    filelist = glob.glob('songs/*.chopro')
    filelist.sort(key=locale.strxfrm)
    for file in filelist:
        for p in excluded_instruments:
            if not p.match(os.path.basename(file)):
                if not file in lines:
                    logging.info("%s is not in songlist." % (file))
                    lines.append(file)
    command = ['/usr/local/bin/chordpro', '--config', 'chordpro-%s.json' % (target_instrument), '--output', 'out/songbook-%s-printshop.pdf' % (target_instrument), '--cover', 'cover/cover-%s.pdf' % (target_instrument)]
    command.extend(lines)
    subprocess.run(command)
