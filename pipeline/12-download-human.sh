#!/bin/bash

# Download UniProt human protein data.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SOURCES="
ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_sprot_human.dat.gz
ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_trembl_human.dat.gz
"

DATADIR="$SCRIPTDIR/../data/original-data"

set -eu

mkdir -p "$DATADIR"

for url in $SOURCES; do
    bn=$(basename "$url")
    if [ -e "$DATADIR/$bn" ]; then
	echo "$DATADIR/$bn exists, skipping download." >&2
    else
	echo "Downloading $url to $DATADIR/$bn ..." >&2
	wget -O "$DATADIR/$bn" "$url"
    fi
done
