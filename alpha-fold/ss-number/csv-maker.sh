#!/bin/bash

find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
  echo "$dir"
  cd $dir
  touch coil.csv beta-sheet.csv beta-bridge.csv turn.csv bend.csv ahelix.csv three-helix.csv 
  cd .. 
done
