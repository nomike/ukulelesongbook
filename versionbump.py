#!/usr/bin/env python3
"""
versionbump.py - Ccalculates the next tag version.

Usage:
    versionbump.py <element> [<amount>]
"""

from distutils.version import LooseVersion
import git
from docopt import docopt

if __name__ == '__main__':
    arguments = docopt(__doc__, version='release.py v. 0.2')

    repo = git.Repo('.')
    versions = [tag.name for tag in repo.tags]
    versions.sort(key=LooseVersion)
    version = versions[-1].split('.')
    if arguments['<amount>']:
        amount = arguments['<amount>']
    else:
        amount = 1
    version[int(arguments['<element>'])] = str(int(version[int(arguments['<element>'])]) + amount)
    for i in range(int(arguments['<element>']) + 1, len(version)):
        version[i] = '0'
    print('.'.join(version))
    
