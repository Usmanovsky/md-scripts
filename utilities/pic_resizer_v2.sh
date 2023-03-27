#!/bin/bash
# resize pictures by x%. $1 is the location of the pics. $2 is the destination folder.i
# $3 is the pic format. $4 is the resize 5.
size=25
fold="resize-$size"
picformat='tiff'
path='.'
look=${1:-$path}
folder=${2:-$fold}
format=${3:-$picformat}
resize=${4:-$size}

conv () {
  dir=$1
  dat=${dir%.*}
  #echo $dat
  dsp=`basename $dat`
  #echo $dsp
  dest=$2
  resize=$3
  convert $dir -resize $resize% $dest/$dsp.tiff 
  #mv $dsp.dssp $2
  }

export -f conv

# serial option. ideal for few files.
#mkdir -p $folder; find $look -maxdepth 1 -iname "*.$format" -exec bash -c "conv \"{}\" $folder $resize" \;

# parallelize with xargs. play around with the -P option to speed things up.
mkdir -p $folder; find $look -maxdepth 1 -iname "*.$format" | xargs -I {} -P 128 bash -c "conv \"{}\" $folder $resize" _ {};
