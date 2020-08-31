#!/bin/sh

if [ ${#} -eq 1 ] ; then
    GVF="build/COMMIT-HASH-${1}"
    VN=$(cd "${1}" ; git rev-parse HEAD 2>/dev/null)
else
    GVF="build/COMMIT-HASH"
    VN=$(git rev-parse HEAD 2>/dev/null)
fi


if test -r "${GVF}" ; then
	VC=$(cat ${GVF})
else
	VC=unset
fi
test "${VN}" = "${VC}" || {
	echo "${VN}" >"${GVF}"
}


