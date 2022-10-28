#!/bin/bash
for file in *dat
do
{
python analyze-ss.py $file
}
done
