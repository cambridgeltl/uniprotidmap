#!/bin/bash

# Download UniProt human protein data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# See https://www.ebi.ac.uk/proteins/api/doc/#/proteins
SOURCE='https://www.ebi.ac.uk/proteins/api/proteins?taxid=9606&size=-1'

DATADIR="$SCRIPTDIR/../data/original-data"

set -eu

mkdir -p "$DATADIR"

bn="human-proteins.json"

if [ -e "$DATADIR/$bn" ]; then
    echo "$DATADIR/$bn exists, skipping download."
else
    read -p "Download 2GB file $bn? [y/n] " answer
    if [[ $answer != "y" && $answer != 'Y' ]]; then
	echo "Exiting without downloading data."
	exit 1
    fi
    echo "Downloading $SOURCE to $DATADIR/$bn ..." >&2
    curl -H 'Accept:application/json' "$SOURCE" > "$DATADIR/$bn"
fi
