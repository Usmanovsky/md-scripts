#!/bin/bash
i=0
name=unlabel
for file in file*
do
{
mv $file $name-$i.csv
let i=$i+1
echo $i
}
done
