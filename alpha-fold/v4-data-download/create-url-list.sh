#!/bin/bash
# create url lists from the batch?.csv files
for x in {1..5}; do python3 create-url-list.py batch$x.csv url-batch$x.csv; done
