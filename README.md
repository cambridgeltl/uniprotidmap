# UniProt ID mappings

Tools for working with UniProt ID mapping data
(<http://www.uniprot.org/mapping/>).

## Quickstart

To download UniProt ID mapping data and generate derived mappings, run

    ./REBUILD-DATA.sh

If succesful, this process generates the files `NCBIGENE-idmapping.dat`
and `NCBIGENE-pr-idmapping.dat` and outputs "DONE" on completion.

Note that this process downloads a 9GB file and may take long to
complete.

## Requirements

- Unix shell and standard tools (e.g. `wget`)
- Python 2.7
- Data from <https://github.com/cambridgeltl/proteinontology>

## Troubleshooting

- `mergemap` step fails with error `no .dat files`: this step requires
  that a copy of https://github.com/cambridgeltl/proteinontology is found
  in a sibling directory (`../proteinontology`) and that the script
  `./REBUILD-DATA.sh` has been succesfully run there. This can be done
  by running

      cd ..
      git clone git@github.com:cambridgeltl/proteinontology.git
      ./proteinontology/REBUILD-DATA.sh
      cd -

  in the root directory of this repository.
