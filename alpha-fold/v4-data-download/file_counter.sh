#!/bin/bash
# Count files in big directories
# $1 is the directory with lots of files
find $1 -type d | while read i; do ls $i | wc -l | tr -d \\n; echo " -> $i"; done | sort -n
