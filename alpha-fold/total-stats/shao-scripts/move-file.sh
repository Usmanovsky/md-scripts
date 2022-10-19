#!/bin/bash

for i in {1..20}
do
{
 mkdir folder-$i
 find . -maxdepth 1 -name "*.pdb" | head -50000 | xargs -i mv "{}" ./folder-$i/
}
done
