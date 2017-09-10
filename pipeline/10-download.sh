#!/bin/bash

# Download source data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SOURCE="ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/idmapping.dat.gz"

DATADIR="$SCRIPTDIR/../data/original-data"

set -eu

mkdir -p "$DATADIR"

bn=$(basename "$SOURCE")

if [ -e "$DATADIR/$bn" ]; then
    echo "$DATADIR/$bn exists, skipping download."
else
    read -p "Download 9GB file $bn? [y/n] " answer
    if [[ $answer != "y" && $answer != 'Y' ]]; then
	echo "Exiting without downloading data."
	exit 1
    fi
    echo "Downloading $SOURCE to $DATADIR/$bn ..." >&2
    wget -O "$DATADIR/$bn" "$SOURCE"    
fi
