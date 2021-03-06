#!/usr/bin/env python3

import logging
import os
import subprocess
from subprocess import run
import sys
import glob
import re
import shutil
import locale
from PyPDF2 import PdfFileReader
locale.setlocale(locale.LC_ALL, '')

rxcountpages = re.compile(b"/Type\s*/Page([^s]|$)", re.MULTILINE|re.DOTALL)
def count_pdf_pages(filename):
    with open(filename, "rb") as file:
        return PdfFileReader(file).numPages

if __name__ == "__main__":
    instrument = sys.argv[1]
    exclude_instrument = sys.argv[2]
    logging.info("Create songbook for %s" % (instrument))
    if not os.path.isdir("build/%s/songs/" % (instrument)):
        os.makedirs("build/%s/songs/" % (instrument))
    if not os.path.isdir("build/%s/paged/songs/" % (instrument)):
        os.makedirs("build/%s/paged/songs/" % (instrument))
    if not os.path.isdir("out/"):
        os.makedirs("out/")
    
    songs = [os.path.basename(x.replace(".chopro", "")) for x in glob.glob("songs/*.chopro") if not x.endswith("-%s.chopro" % (exclude_instrument))]
    songs.sort(key=locale.strxfrm)

    for song in songs:
        if (not os.path.isfile("build/%s/songs/%s.pdf" % (instrument, song))) or max(os.path.getmtime("songs/%s.chopro" % (song)), os.path.getmtime("chordpro-%s.json" % (instrument))) > os.path.getmtime("build/%s/songs/%s.pdf" % (instrument, song)):
            print('Generating song "%s" for %s' % (song, instrument))
            result = subprocess.run(["chordpro", "--config", "chordpro-%s.json" % (instrument), "--config", "no-pagenumbers.json", "--output", "build/%s/songs/%s.pdf" % (instrument, song), "songs/%s.chopro" % (song)], capture_output=True)
            print(result.stderr.decode("utf-8"), file=sys.stderr)
            if result.returncode != 0:
                raise Exception("Error at song generation")
            if count_pdf_pages("build/%s/songs/%s.pdf" % (instrument, song)) % 2 != 0:
                subprocess.run(["pdfunite", "build/%s/songs/%s.pdf" % (instrument, song), "build/empty.pdf", "build/%s/paged/songs/%s.pdf" % (instrument, song)])
            else:
                shutil.copyfile("build/%s/songs/%s.pdf" % (instrument, song), "build/%s/paged/songs/%s.pdf" % (instrument, song))
    if count_pdf_pages("newcover/%s.pdf" % instrument) % 2 == 0:
        subprocess.run(["pdfunite", "newcover/%s.pdf" % (instrument), "build/empty.pdf", "build/%s/paged/cover.pdf" % (instrument)])
    else:
        shutil.copyfile("newcover/%s.pdf" % (instrument), "build/%s/paged/cover.pdf" % (instrument))

    if count_pdf_pages("build/%s/toc.pdf" % instrument) % 2 == 1:
        subprocess.run(["pdfunite", "build/%s/toc.pdf" % (instrument), "build/empty.pdf", "build/%s/paged/toc.pdf" % (instrument)])
    else:
        shutil.copyfile("build/%s/toc.pdf" % (instrument), "build/%s/paged/toc.pdf" % (instrument))
    exec = ["pdfunite", "build/%s/paged/cover.pdf" % (instrument), "build/%s/paged/toc.pdf" % (instrument)]
    exec.extend(["build/%s/paged/songs/%s.pdf" % (instrument, x) for x in songs])
    exec.append("out/songbook-%s.pdf" % (instrument))
    subprocess.run(exec)
