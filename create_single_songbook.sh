#!/bin/bash

instrument="${1}"
noinstrument="${2}"

echo "Generating single songbook for ${instrument}..."

# ensure that our build directory is present
mkdir -p "build/${instrument}/songs"
(
    cd songs
    # create an individual PDF for each song
    for song in *.chopro ; do
        echo "${song}" | grep -q -- "-${noinstrument}.chopro" && continue
        chordpro --config ../chordpro-${instrument}.json --output "../build/${instrument}/songs/${song%.chopro}.pdf" "${song}"
        # if the song has an odd number of pages, add an empty page
        if [[ $(( $( pdfinfo "../build/${instrument}/songs/${song%.chopro}.pdf" | grep "Pages:" | awk '{print $2}' ) % 2 )) -eq 1 ]]; then
            pdfunite "../build/${instrument}/songs/${song%.chopro}.pdf" ../build/empty.pdf "../build/${instrument}/temp.out"
            mv "../build/${instrument}/temp.out" "../build/${instrument}/songs/${song%.chopro}.pdf"
        fi
    done
)

# Make sure the cover has an odd number of pages
if [[ $(( $( pdfinfo "cover/cover-${instrument}.pdf" | grep "Pages:" | awk '{print $2}' ) % 2 )) -eq 0 ]]; then
    pdfunite "cover/cover-${instrument}.pdf" ../build/empty.pdf "../build/${instrument}/temp.out"
    mv "../build/${instrument}/temp.out" "build/${instrument}/cover.pdf"
else
    cp "cover/cover-${instrument}.pdf" "build/${instrument}/cover.pdf"
fi

# Make sure the toc has an even number of pages
if [[ $(( $( pdfinfo "build/${instrument}/toc.pdf" | grep "Pages:" | awk '{print $2}' ) % 2 )) -eq 1 ]]; then
    pdfunite "build/${instrument}/toc.pdf" ../build/empty.pdf "../build/${instrument}/temp.out"
    mv "../build/${instrument}/temp.out" "build/${instrument}/toc.pdf"
fi

pdfunite "build/${instrument}/cover.pdf" "build/${instrument}/toc.pdf" "build/${instrument}/songs/"*.pdf out/songbook-${instrument}-single.pdf