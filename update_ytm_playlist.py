#!/usr/bin/env python3

from ytmusicapi import YTMusic
from glob import glob
import os
import json

def get_song(title):
    songs = ytmusic.search(query=title, filter="songs", limit=1)
    if len(songs) == 0:
        raise Exception("Could not find song {}".format(title))
    return songs[0]

if __name__ == "__main__":
    ytmusic = YTMusic('config/headers_auth.json')
    playlisttitle = "nomike's ukulele songbook"
    playlists = [playlist for playlist in ytmusic.get_library_playlists() if playlist['title'] == playlisttitle]
    if len(playlists) == 0:
        playlist = ytmusic.create_playlist(title=playlisttitle, description="Auto Playlist for nomike's ukulele songbook", privacy_status="PUBLIC")
    else:
        playlist = playlists[0]

    for songtitle in [os.path.basename(filename).split('.chopro')[0] for filename in glob('songs/*.chopro')]:
        try:
            if os.path.exists(f'songs/{songtitle}.json'):
                with open(f'songs/{songtitle}.json', 'r') as song_info_file:
                    song_info = json.load(song_info_file)
            else:
                song_info = {}
                song = get_song(songtitle)
                song_info['YouTubeVideoId'] = song['videoId']
                with open(f'songs/{songtitle}.json', 'w') as song_info_file:
                    json.dump(song_info, song_info_file)
            
            ytmusic.add_playlist_items(playlist['playlistId'], [song_info['YouTubeVideoId']])
        except Exception:
            pass
