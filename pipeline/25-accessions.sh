#!/bin/bash

# Extract accession numbers from UniProt data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/original-data"
OUTDIR="$SCRIPTDIR/../data/accessions/"

set -eu

mkdir -p "$OUTDIR"

set +e
files=$(find "$INDIR" -maxdepth 1 -name 'uniprot_*_human.dat.gz' 2>/dev/null)
set -e

if [[ ! -e "$INDIR" ]] || [[ -z "$files" ]]; then
    echo "ERROR: no input files found in $INDIR" >&2
    exit 1
fi

for f in $files; do
    bn=$(basename "$f" .dat.gz)
    o="$OUTDIR/${bn#uniprot_}-accessions.txt"
    if [[ -s "$o" && "$o" -nt "$f" ]]; then
	echo "Newer $o exists, skipping ..." >&2
    else
	echo "Extracting accession numbers from $f to $o" >&2
	zcat "$f" \
	    | egrep '^AC[[:space:]]' \
	    | perl -pe 's/^AC\s*//' \
	    | perl -pe 's/\s*;\s*/\n/g' \
	    | egrep . \
	    > "$o"
    fi
done
