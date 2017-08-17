#!/bin/bash

# Extract mapping between UniProt and NCBI Gene IDs from source data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/original-data"
OUTDIR="$SCRIPTDIR/../data/idmappings/"

set -eu

mkdir -p "$OUTDIR"

f="$INDIR/idmapping.dat.gz"
o="$OUTDIR/GeneID-idmapping.dat"

if [[ -s "$o" && "$o" -nt "$f" ]]; then
    echo "Newer $o exists, skipping ..." >&2
else
    echo "Extracting mapping $f to $o..." >&2
    zcat "$f" | egrep '^[^[:space:]]+'$'\tGeneID\t' > "$o"
fi
