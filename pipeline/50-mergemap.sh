#!/bin/bash

# Merge UniProt ID mappings

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REPOURL="https://github.com/cambridgeltl/proteinontology"
REPOGIT="git@github.com:cambridgeltl/proteinontology.git"
REPONAME="proteinontology"

INDIR1="$SCRIPTDIR/../data/idmappings"
INDIR2="$SCRIPTDIR/../../proteinontology/data/idmappings"
OUTDIR="$SCRIPTDIR/../data/mergedmappings"

set -eu

mkdir -p "$OUTDIR"

set +e
files1=$(find "$INDIR1" -maxdepth 1 -name '*.dat' 2>/dev/null)
files2=$(find "$INDIR2" -maxdepth 1 -name '*.dat' 2>/dev/null)
set -e

if [[ ! -e "$INDIR1" ]] || [[ -z "$files1" ]]; then
    echo "ERROR: no .dat files found in $INDIR1" >&2
    exit 1
fi
    
if [[ ! -e "$INDIR2" ]] || [[ -z "$files2" ]]; then
    cat <<EOF >&2
ERROR: no .dat files found in $INDIR2

Merged mappings require data generated by tools found in the repository
$REPOURL. Try the following:

    cd ..
    git clone $REPOGIT
    ./$REPONAME/REBUILD.sh
    cd -

EOF
    exit 1
fi

for f1 in "$files1"; do
    for f2 in "$files2"; do
	b1=$(basename "$f1" .dat)
	b2=$(basename "$f2" .dat)
	b1=${b1%-idmapping}
	b2=${b2%-idmapping}
	o="$OUTDIR/$b1-$b2-idmapping.dat"
	if [[ -s "$o" && "$o" -nt "$f1" && "$o" -nt "$f2" ]]; then
	    echo "Newer $o exists, skipping ..." >&2
	else
	    echo "Merging $f1 and $f2 to $o" >&2
	    python "$SCRIPTDIR/../scripts/mergemappings.py" "$f1" "$f2" > "$o"
	fi
    done
done
