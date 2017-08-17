#!/usr/bin/env python

# Merge two mappings to UniProt IDs to create a "bridged" mapping
# between the ID spaces.

from __future__ import print_function

import sys
import logging

from logging import info, warning, error
from collections import defaultdict


logging.basicConfig(level=logging.INFO)


def argparser():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('map1', metavar='FILE', help='First mapping')
    ap.add_argument('map2', metavar='FILE', help='Second mapping')
    return ap


class FormatError(Exception):
    pass


def read_mapping(fn):
    read = 0
    mapping = defaultdict(list)
    with open(fn) as f:
        for i, l in enumerate(f, start=1):
            l = l.rstrip('\n')
            f = l.split('\t')
            if len(f) != 3:
                raise FormatError('expected 3 TAB-separated values, got {} on line {} in {}: {}'.format(len(f), i, fn, l))
            id1, id_type, id2 = f
            mapping[id1].append((id_type, id2))
            read += 1
    info('Read {} from {}'.format(read, fn))
    return mapping


def invert_mapping(mapping):
    inverted = defaultdict(list)
    for id1, ids in mapping.iteritems():
        for id_type, id2 in ids:
            inverted[id2] = (id_type, id1)
    return inverted


def merge_mappings(map1, map2):
    matched, missed, pairs = 0, 0, 0
    #map1 = invert_mapping(map1)
    #map2 = invert_mapping(map2)
    for id_, list1 in map1.iteritems():
        if id_ not in map2:
            missed += 1
            continue
        else:
            matched += 1
            list2 = map2[id_]
        for type1, id1 in list1:
            for type2, id2 in list2:
                print('{}\t{}-{}\t{}'.format(id1, type1, type2, id2))
                pairs += 1
    info('matched {} and missed {} IDs (output {} pairs)'.format(
        matched, missed, pairs))


def main(argv):
    args = argparser().parse_args(argv[1:])
    map1 = read_mapping(args.map1)
    map2 = read_mapping(args.map2)
    merge_mappings(map1, map2)
    

if __name__ == '__main__':
    sys.exit(main(sys.argv))
