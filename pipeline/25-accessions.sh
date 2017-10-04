#!/bin/bash

# Extract accession numbers from UniProt JSON data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/original-data"
OUTDIR="$SCRIPTDIR/../data/accessions/"

set -eu

mkdir -p "$OUTDIR"

set +e
files=$(find "$INDIR" -maxdepth 1 -name '*-proteins.json' 2>/dev/null)
set -e

if [[ ! -e "$INDIR" ]] || [[ -z "$files" ]]; then
    echo "ERROR: no .input files found in $INDIR" >&2
    exit 1
fi

for f in $files; do
    bn=$(basename "$f")
    o="$OUTDIR/${bn%-proteins.json}-accessions.txt"
    if [[ -s "$o" && "$o" -nt "$f" ]]; then
	echo "Newer $o exists, skipping ..." >&2
    else
	echo "Extracting accession numbers from $f to $o" >&2
	python "$SCRIPTDIR/../scripts/getaccession.py" "$f" > "$o"
    fi
done
