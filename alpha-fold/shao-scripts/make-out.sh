#!/bin/bash
for i in {16..46}
#for fold in 3* 4* 5* 6* 7* 8* 9*
do
{
fold=swiss-$i
echo $fold
cd $fold
rm -rf *data
nohup ./analyze-res.sh &
#nohup ./stat-res.sh &
cd ..
}
done
