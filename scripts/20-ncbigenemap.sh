#!/bin/bash

# Extract mapping between UniProt and NCBI Gene IDs from source data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INDIR="$SCRIPTDIR/../data/original-data"
OUTDIR="$SCRIPTDIR/../data/idmappings/"

set -eu

mkdir -p "$OUTDIR"

zcat "$INDIR/idmapping.dat.gz" \
    | egrep '^[^[:space:]]+'$'\tGeneID\t' \
    > "$OUTDIR/GeneID-idmapping.dat"
