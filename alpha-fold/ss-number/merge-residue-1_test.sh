#!/bin/bash

find ../ -maxdepth 1 -mindepth 1 -type d | while read dir; do
  echo "$dir"
  #cd $dir  
done


for file in *dat
do
{
res=${file%.*}
echo $res
#for i in {15..46}
for folder in *v2-*
do
{

x=`wc -l ../swiss-1/AF-A0JZ79-F1-model_v2.out`; lines=($x);  line=${lines[0]};
line_no=$((line / 10))

if (( $line_no>10 ))
then
  line_no=10
fi

cat ../$folder/$file >> $file
}
done
}
done
