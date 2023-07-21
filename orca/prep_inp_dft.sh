#!/bin/bash
# old_prot is the old protein name. preferably use something like xxxx
# new_prot is the new pdb ID you want.
old_prot=$1
new_prot=$2

sed -i "s/$old_prot/$new_prot/g" $new_prot.inp
sed -i "s/$old_prot/$new_prot/g" submit_shifter_orca.sh
