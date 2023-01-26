#!/bin/bash

# make batch2
python find-diff-pandas.py uniprot-200-unaffected.csv used-batch1.csv uniprot-200-1.csv
python select-samples.py uniprot-200-1.csv used-batch2.csv

#make batch3
python find-diff-pandas.py uniprot-200-1.csv used-batch2.csv uniprot-200-2.csv
python select-samples.py uniprot-200-2.csv used-batch3.csv

#make batch4
python find-diff-pandas.py uniprot-200-2.csv used-batch3.csv uniprot-200-3.csv
python select-samples.py uniprot-200-3.csv used-batch4.csv

#make batch5
python find-diff-pandas.py uniprot-200-3.csv used-batch4.csv uniprot-200-4.csv
python select-samples.py uniprot-200-4.csv used-batch5.csv
