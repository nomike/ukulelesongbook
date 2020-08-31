#!/bin/bash

if [ ${#} -eq 1 ] ; then
    GVF="build/COMMIT-HASH-${1}"
    pushd "${1}" >/dev/null
else
    GVF="build/COMMIT-HASH"
    pushd . >/dev/null
fi

VN=$(git rev-parse HEAD 2>/dev/null) || VN="not a git directory"
popd >/dev/null

if test -r "${GVF}" ; then
	VC=$(cat ${GVF})
else
	VC=unset
fi
test "${VN}" = "${VC}" || {
	echo "${VN}" >"${GVF}"
}


