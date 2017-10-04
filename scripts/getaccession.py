#!/usr/bin/env python

# Extract accession numbers from UniProt JSON data.

# See https://www.ebi.ac.uk/proteins/api/doc/#/proteins for data format.

from __future__ import print_function

import sys
import logging

from logging import debug, info, warn, error

try:
    import ujson as json
except ImportError:
    import json


logging.basicConfig(level=logging.INFO)


def argparser():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('proteins', metavar='FILE',
                    help='UniProt protein data')
    return ap


def get_accessions(fn, options):
    with open(fn) as f:
        data = json.load(f)
    info('loaded {} entries from {}'.format(len(data), fn))
    accessions = [d['accession'] for d in data]
    return accessions


def main(argv):
    args = argparser().parse_args(argv[1:])
    accessions = get_accessions(args.proteins, args)
    for a in accessions:
        print(a)


if __name__ == '__main__':
    sys.exit(main(sys.argv))
