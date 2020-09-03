#!/bin/bash -e

basedir="$(pwd)"
eval "$(./docopts -V - -h - : "$@" <<EOF
Usage: ${0} --instrument=<instrument> [--no-record] [--copies=<copies>] [--no-print]
       ${0} --version
       ${0} --help
Options:
      --instrument=<instrument> Could either be ukulele or guitar
      --no-record               Do not keep record of the printed pages
      --no-print                Don't actually print but output the print command to the terminal
      --copies=<copies>         How many copies to print
      --help                    Show help options.
      --version                 Print program version.
----
$(basename "${0}") - v. 0.0.2
Copyright (C) 2020 nomike Postmann
License GPLv3
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
)"
mkdir -p config
if [ "${instrument}" != "guitar" ] && [ "${instrument}" != "ukulele" ] ; then
    echo "${0}: Error: Unsupported instrument" >&2
    exit 1
fi

print_range=$((
    test -r config/last_printed_${instrument}_commit && export last_printed_commit="$(cat config/last_printed_${instrument}_commit)" || export last_printed_commit="4b825dc642cb6eb9a060e54bf8d69288fbee4904"
    export IFS=$'\n'
    (
        cd songs
        for string in $(git --no-pager diff --name-only "${last_printed_commit}" HEAD  | grep "chopro" | tr -d '"') ; do
            basename "$(printf "${string}")"
        done
    )
) | xargs --no-run-if-empty -d '\n' ./generate_print_string.py --instrument=${instrument})
if [ "${print_range}" == "" ] ; then
    echo "${0}: Info: Nothing to print" >&2
    exit 0
fi
print_command="lp -P \"${print_range}\" \"${basedir}/out/songbook-${instrument}.pdf\""
if ${no_print} ; then
    echo "${print_command}"
else
    eval "${print_command}"
fi
if ! ${no_record} ; then
    (
        cd songs
        git rev-parse HEAD > "${basedir}/config/last_printed_${instrument}_commit"
    )
fi
