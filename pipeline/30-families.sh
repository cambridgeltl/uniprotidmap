#!/bin/bash

# Extract mapping from UniProt ID to family from source data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/original-data"
OUTDIR="$SCRIPTDIR/../data/idmappings/"

set -eu

mkdir -p "$OUTDIR"

f="$INDIR/similar.txt"
o="$OUTDIR/family-mapping.tsv"

if [[ -s "$o" && "$o" -nt "$f" ]]; then
    echo "Newer $o exists, skipping ..." >&2
else
    echo "Extracting mapping $f to $o..." >&2
    python "$SCRIPTDIR/../scripts/getfamilies.py" "$f" > "$o"
fi
