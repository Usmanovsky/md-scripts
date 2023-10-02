#!/bin/bash
# This script calculates rmsd, rmsf, contact map and sasa.
#source ~/.bashrc
mvv(){ mkdir -p "${@: -1}" && mv "${@:1:$#-1}" "$_"; }

h='-noH'
AP="${1:-APOE}"

# RMSD for c-alpha
echo 3 3 | gmx_gpu rms -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -o rmsd-$AP.xvg -nice 1
mvv rmsd*xvg rmsd

# RMSF for c-alpha
echo 3 | gmx_gpu rmsf -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -o rmsf-$AP.xvg -nice 1
mvv rmsf*xvg rmsf

# contact-map for c-alpha
echo 3 | gmx_gpu mdmat -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -mean contact-$AP.xpm -nice 1
#mvv contact*xpm cmap

# convert contact-map to eps file
gmx_gpu xpm2ps -f contact-$AP.xpm -rainbow red -o contact-$AP.eps -title none
mvv contact*xpm contact*eps cmap

# SASA
#gmx_gpu sasa -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol.ndx -or $AP$h-sasa-res.xvg -o $AP$h-sasa-total.xvg -odg $AP$h-sasa-energy.xvg -tu ns
#mvv *sasa*xvg sasa

# SASA for protein without H atoms
echo 2 | gmx_gpu sasa -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol.ndx -or $AP$h-sasa-res.xvg -o $AP$h-sasa-total.xvg -odg $AP$h-sasa-energy.xvg -tu ns
#mvv *-sasa-*xvg sasa

# SASA for protein with H atoms 
echo 1 | gmx_gpu sasa -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol.ndx -or $AP-sasa-res.xvg -o $AP-sasa-total.xvg -odg $AP-sasa-energy.xvg -tu ns
mvv *-sasa-*xvg sasa

# SS
export DSSP=/home/AD/ulab222/miniconda3/envs/mkdssp/bin/mkdssp #/data1/qsh226/anaconda3/bin/mkdssp
echo 7 | gmx_gpu do_dssp -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -ssdump $AP-ssdump.dat -o $AP-ss.xpm -sc $AP-scount.xvg
mvv *ssdump.dat *scount.xvg *-ss.xpm ss

# trjconv
#echo 2 | gmx_gpu trjconv -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -o $AP-trj.pdb -pbc mol 

# send email when job is complete
echo "Completed $AP analysis"
address="ulab20464@gmail.com"
DATETIME="$(date '+%Y-%m-%d_%H-%M-%S')"
subject="$AP complete ${DATETIME}"
body="Backup to HDD2 is complete"
#attach=backupHDD2-lab93_$x.log
echo $body | mail -s $subject $address  # -a $attach
