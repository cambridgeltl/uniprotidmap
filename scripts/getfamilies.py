#!/usr/bin/env python

# Extract UniProt ID -> family name mapping from UniProt data.

# UniProt protein family data is (at present) found in a custom
# human-readable format at http://www.uniprot.org/docs/similar.txt.

from __future__ import print_function

import sys
import re
import logging

from logging import debug, info, warn, error


logging.basicConfig(level=logging.INFO)


class FormatError(Exception):
    pass


def argparser():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('families', metavar='FILE',
                    help='UniProt family data (similar.txt)')
    return ap


def parse_member(member):
    """Parse UniProt family data member string, return (name, id)."""
    m = re.match(r'^(\S+)\s+\((\S+)\)\s*$', member)
    if not m:
        raise FormatError(member)
    return m.groups()


def parse_families(fn):
    """Parse custom text-based format of UniProt family data, return
    list of (id, name, family) tuples.
    """
    # See http://www.uniprot.org/docs/similar.txt for format
    parsed = []
    with open(fn) as f:
        in_header = True
        current_family, previous_family = None, None
        for ln, line in enumerate(f, start=1):
            line = line.rstrip('\n')
            # Skip initial lines until one with "II. Families"
            if in_header and line.strip() == "II. Families":
                in_header = False
                continue
            elif in_header:
                continue
            # End parsing when encountering footer starting with "---"
            if line.startswith('---'):
                break
            # Blank lines signal end of family
            if not line.strip():
                if current_family is not None:
                    previous_family = current_family
                current_family = None
                continue
            # Lines not starting with space are family names
            if line and not line[0].isspace():
                if current_family is not None:
                    raise FormatError('missing separator {} line {}: {}'.format(
                        fn, ln, line))
                current_family = line.strip()
                debug('parsing {}'.format(current_family))
                continue
            # Lines with "Highly divergent:" relate to previous family
            if line.strip().lower() == 'highly divergent:':
                if current_family is not None:
                    raise FormatError('missing separator {} line {}: {}'.format(
                        fn, ln, line))
                if previous_family is None:
                    raise FormatError('missing previous {} line {}: {}'.format(
                        fn, ln, line))
                current_family = previous_family + ' (highly divergent)'
                debug('parsing {}'.format(current_family))
                continue
            # Assume list of family members
            if current_family is None:
                raise FormatError('no family {} line {}: {}'.format(
                    fn, ln, line))
            # Comma-separated list with possible terminating comma
            members = [m.strip() for m in line.strip().split(',') if m.strip()]
            try:
                members = [parse_member(m) for m in members]
            except FormatError:
                raise FormatError('failed to parse {} line {}: {}'.format(
                    fn, ln, line))
            for m in members:
                parsed.append((m[1], m[0], current_family))
        if in_header:
            raise FormatError('failed to find header end in {}'.format(fn))
    info('parsed {} mappings from {}'.format(len(parsed), fn))
    return parsed


def main(argv):
    args = argparser().parse_args(argv[1:])
    families = parse_families(args.families)
    for id_, name, family in families:
         print('{}\tfamily\t{}\t{}'.format(id_, family, name))


if __name__ == '__main__':
    sys.exit(main(sys.argv))
