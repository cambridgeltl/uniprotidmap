#!/bin/bash

# Invert mappings.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/idmappings"
OUTDIR="$SCRIPTDIR/../data/idmappings"

set -eu

mkdir -p "$OUTDIR"

for f in $(find "$INDIR" -maxdepth 1 -name '*.dat'); do
    b=$(basename $f .dat)
    o="$OUTDIR/"${b%.dat}.inv.dat
    if [[ -s "$o" && "$o" -nt "$f" ]]; then
	echo "Newer $o exists, skipping ..." >&2
    else
	echo "Inverting mapping $f to $o..." >&2
	perl -pe 's/(\S+)\t(\S+)\t(\S+)/$3\t$2\t$1/ or die "Error: $_"' $f > $o
    fi
done
