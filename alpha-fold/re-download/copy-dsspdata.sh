#!/bin/bash
for x in {2..5}
do
{
#cd batch-$x
for i in {1..20} 
do
{
mkdir ./batch-$x/dssp-data-$i; 
find /pscratch/qsh226_uksr/uniprot/uniprot-only/batch-download/batch$x/folder-$i/ -name "AF*.dssp" | xargs -I {} -P 1000 cp {} ./batch-$x/dssp-data-$i/; 
#cd ..
}
done
}
done
