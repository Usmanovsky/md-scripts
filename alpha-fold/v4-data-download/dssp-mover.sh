#!/bin/bash
# move pdb files to different folders
dssp_move () {
  dir=$1
  dat=${dir%.*}
  #echo $dat
  dsp=`basename $dat`
  echo $dsp
  mv $dsp.dssp $2
  }

export -f dssp_move

for i in {1..20}
do
{

find folder-$i/ -maxdepth 1 -name "*.pdb" -exec bash -c "dssp_move \"{}\" folder-$i" \;
#find $1 -maxdepth 1 -type f -name "AF*.pdb" | xargs -I {} -P 512 bash -c 'dat_to_out  "$@"' _ {};
 }
done
