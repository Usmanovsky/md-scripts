#!/bin/bash
# replace default file paths in config/*yaml files
# for file in ./*.yaml; do sed -i 's/~\/scratch/\/scratch\/ulab222\/multi-view\/pretrain-test/g' $file; done
for file in ./*.yaml; do sed -i 's/multi-vew/multi-view/g' $file; done
