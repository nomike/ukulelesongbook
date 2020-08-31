#!/bin/bash

if [ ${#} -eq 1 ] ; then
    GCVF="build/COMMIT-HASH-${1}"
    GTVF="build/TAG-${1}"
    pushd "${1}" >/dev/null
else
    GCVF="build/COMMIT-HASH"
    GTVF="build/TAG"
    pushd . >/dev/null
fi

VN=$(git rev-parse HEAD 2>/dev/null) || VN="not a git directory"
TN=$(git describe --tags 2>/dev/null) || TN="not a git directory"
popd >/dev/null

if test -r "${GCVF}" ; then
	VC=$(cat ${GCVF})
else
	VC=unset
fi
if test -r "${GTVF}" ; then
	TC=$(cat ${GTVF})
else
	TC=unset
fi
test "${VN}" = "${VC}" || {
	echo "${VN}" >"${GCVF}"
}
test "${TN}" = "${TC}" || {
	echo "${TN}" >"${GTVF}"
}

