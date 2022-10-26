#!/bin/bash

find ../data/ -type d | xargs -I {} -P 1000 cp -r {} ./batch-1/;
