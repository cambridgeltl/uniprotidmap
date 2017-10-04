#!/usr/bin/env python

import sys

try:
    import ujson as json
except ImportError:
    import json


if __name__ == '__main__':
    for fn in sys.argv[1:]:
        with open(fn) as f:
            d = json.load(f)
        json.dump(d, sys.stdout, sort_keys=True, indent=2)
