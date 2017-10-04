#!/bin/bash

# Download UniProt protein family data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SOURCE="http://www.uniprot.org/docs/similar.txt"

DATADIR="$SCRIPTDIR/../data/original-data"

set -eu

mkdir -p "$DATADIR"

bn=$(basename "$SOURCE")

if [ -e "$DATADIR/$bn" ]; then
    echo "$DATADIR/$bn exists, skipping download."
else
    echo "Downloading $SOURCE to $DATADIR/$bn ..." >&2
    wget -O "$DATADIR/$bn" "$SOURCE"    
fi
