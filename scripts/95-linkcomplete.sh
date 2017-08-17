#!/bin/bash

# Link processed data for convenience.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/idmappings/"
OUTDIR="$SCRIPTDIR/../"

set -eu

for f in $(find "$INDIR" -maxdepth 1 -name '*.dat'); do
    b=$(basename $f)
    o="$OUTDIR/$b"
    if [[ -e "$o" ]]; then
	echo "$o exists, skipping ..." >&2
    else
	echo "Linking $o to $f ..." >&2
	ln -s "$f" "$o"
    fi
done
