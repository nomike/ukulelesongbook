#!/usr/bin/env python3
"""
Usage:
    create_printshop_songbook.py --instrument=<instrument> --variant=<varian>
"""
from glob import glob
import sys
import subprocess
import os
from docopt import docopt
import logging
import locale
from PyPDF2 import PdfFileReader

locale.setlocale(locale.LC_ALL, '')

instruments = ['ukulele', 'guitar', 'piano']

class restart(Exception):
    pass

def count_pdf_pages(filename):
    with open(filename, "rb") as file:
        return PdfFileReader(file).numPages

def count_song_pages(song, instrument):
    generate_song_pdf(song, instrument)
    return count_pdf_pages(f"build/{instrument}/songs/{song}.pdf")

def generate_song_pdf(song, instrument):
    if (not os.path.isfile(f"build/{instrument}/songs/{song}.pdf")) or max(os.path.getmtime(f"songs/{song}.chopro"), os.path.getmtime(f"chordpro.json"), os.path.getmtime(f"{instrument}.json"), os.path.getmtime("printshop.json")) > os.path.getmtime(f"build/{instrument}/songs/{song}.pdf"):
        logging.info(f'Generating song "{song}" for {instrument}')
        command = ["chordpro", "--config", "chordpro.json", "--config", "printshop.json", "--config", f"{instrument}.json", "--output", f"build/{instrument}/songs/{song}.pdf", f"songs/{song}.chopro"]
        logging.debug(f"Executing chordpro:\n{command}")
        result = subprocess.run(command, capture_output=True)
        if result.returncode != 0:
            logging.error(f'chordpro error: {result.stderr.decode("utf-8")}')
            raise Exception("Error at song generation")

def create_regular_songlist(exclude_instruments):
    songs = []
    for song in [os.path.basename(x) for x in glob("songs/*.chopro")]:
        append = True
        for exclude_instrument in exclude_instruments:
            if song.endswith(f'-{exclude_instrument}.chopro'):
                logging.debug(f'Ignoring {song}')
                append = False
        if append:
            songs.append(song)
    songs.sort(key=locale.strxfrm)
    return songs

def create_printshop_songlist(target_instrument, exclude_instruments):
    """
    Create a list of songs which is intended to be as close as possible to alphabetic sorting,
    while still ensuring that each song starts on the left to keep turning pages to a minimum.
    """
    songs = create_regular_songlist(exclude_instruments)
    songs.sort(key=locale.strxfrm)
        
    sorted_songs = []
    while len(songs) > 0:
        try:
            song = songs[0]
            sorted_songs.append(song)
            songs.remove(song)
            if count_song_pages(os.path.basename(song).replace('.chopro', ''), target_instrument) % 2 == 0:
                raise restart()
            else:
                for song in songs:
                    if count_song_pages(os.path.basename(song).replace('.chopro', ''), target_instrument) % 2 == 1:
                        sorted_songs.append(song)
                        songs.remove(song)
                        raise restart()
        except restart:
            pass
    return sorted_songs

if __name__ == "__main__":
    # Basic setup and parameter management
    os.makedirs("out", exist_ok=True)
    logging.basicConfig(level=logging.INFO)
    arguments = docopt(__doc__, version='create_songbook.py v. 1.0')
    if not arguments["--instrument"] in instruments:
        raise ValueError("Unsupported instrument")
    if not arguments["--variant"] in ['regular', 'printshop']:
        raise ValueError("Unsupported variant")
    target_instrument = arguments["--instrument"]
    
    # ensure necessary directories are present
    if not os.path.isdir("build/%s/songs/" % (target_instrument)):
        os.makedirs("build/%s/songs/" % (target_instrument))
    if not os.path.isdir("build/%s/paged/songs/" % (target_instrument)):
        os.makedirs("build/%s/paged/songs/" % (target_instrument))
    if not os.path.isdir("out/"):
        os.makedirs("out/")


    if arguments['--variant'] == 'regular':
        songs = create_regular_songlist([i for i in instruments if i != target_instrument])
    else:
        songs = create_printshop_songlist(target_instrument, [i for i in instruments if i != target_instrument])

    # run chordpro to create the songbook
    command = ['chordpro', '--config', 'chordpro.json', '--config', f"{arguments['--variant']}.json", '--config', f'{target_instrument}.json', '--output', f"out/songbook-{target_instrument}-{arguments['--variant']}.pdf", '--cover', f'newcover/{target_instrument}.pdf', '--csv']
    command.extend([os.path.join('songs', song) for song in songs])
    logging.info("Calling chordpro: %s" % (' '.join([ '"' + i + '"' for i in command])))
    subprocess.run(command)
