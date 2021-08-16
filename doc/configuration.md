***Note:** There are a couple of json files in the root directory, which are
used to configure chordpro. These should not be touched.*

# config/bookname
Contains the name of the book. This will be printed on the cover page.

# config/headers_auth.json
This is used by `update_ytm_playlist.py` to authenticate against youtube music.
Follow the [https://ytmusicapi.readthedocs.io/en/latest/setup.html](ytmusicapi
setup guide) to set this up.

# config/newcover_theme_name
Contains the theme used for the cover.

# upload_target
Contains a path which will be used by the "scp" command to upload the songbooks
to e.g. a webspace.
