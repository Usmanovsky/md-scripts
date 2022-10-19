#!/bin/bash

find ../ -maxdepth 2 -mindepth 1 -type f -name "*.out" | while read dir; do
  echo "$dir"/*.out
done
