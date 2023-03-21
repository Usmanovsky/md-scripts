#!/bin/bash
# This assumes you've already used select-samples.py to create batch1.csv.
# This script will then generate unique batches 2-5

# make batch2
python3 find-diff-pandas.py ../v4-batch-updated-accessions/csv-files/accession_ids.csv batch1.csv not-in-batch-1.csv
python3 select-samples.py not-in-batch-1.csv 2  #batch2.csv

#make batch3
python3 find-diff-pandas.py not-in-batch-1.csv batch2.csv not-in-batch-2.csv
python3 select-samples.py not-in-batch-2.csv 3  #batch3.csv

#make batch4
python3 find-diff-pandas.py not-in-batch-2.csv batch3.csv not-in-batch-3.csv
python3 select-samples.py not-in-batch-3.csv 4  #batch4.csv

#make batch5
python3 find-diff-pandas.py not-in-batch-3.csv batch4.csv not-in-batch-4.csv
python3 select-samples.py not-in-batch-4.csv 5  #batch5.csv
