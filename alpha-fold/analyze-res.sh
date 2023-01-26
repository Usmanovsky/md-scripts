#!/bin/bash
for file in *out
do
{
python analyze-residue.py $file
}
done
