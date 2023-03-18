#!/bin/bash
# replace default file paths in config/*yaml files
extension="*.yaml"
old=''
new=''
ext=${1:-$extension}  # file extension you want to loop through
tsoho=${2:-$old}  # old string you want to change
sabo=${3:-$new}  # new string
#for file in ./*.yaml; do sed -i 's/~\/scratch/\/scratch\/ulab222\/multi-view\/pretrain-test/g' $file; done
for file in ./$ext; do sed -i "s/$tsoho/$sabo/g" $file; done
