#!/bin/bash
# 10/26/2022 added 5-turn-helix
find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
  echo "$dir"
  cd $dir
  touch coil.csv beta-sheet.csv beta-bridge.csv turn.csv bend.csv ahelix.csv three-helix.csv five-helix.csv 
  cd .. 
done
