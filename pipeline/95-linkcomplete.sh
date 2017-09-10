#!/bin/bash

# Link processed data for convenience.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIRS="
$SCRIPTDIR/../data/idmappings/
$SCRIPTDIR/../data/mergedmappings/
"
OUTDIR="$SCRIPTDIR/../"

set -eu

for d in $INDIRS; do
    for f in $(find "$d" -maxdepth 1 -name '*.dat'); do
	b=$(basename $f)
	o="$OUTDIR/$b"
	if [[ -e "$o" ]]; then
	    echo "$o exists, skipping ..." >&2
	else
	    echo "Linking $o to $f ..." >&2
	    ln -s "$f" "$o"
	fi
    done
done
