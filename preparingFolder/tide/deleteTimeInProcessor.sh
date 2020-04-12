#!/bin/bash


## This is a _dangerous_ script.

## It aims to delete the re-constructed time folder in processor*
## 48 is the number of processors.


find . -maxdepth 1  -type d -regex "./[0-9]+*\.?[0-9]+" > log.t
<log.t rev | cut -d/ -f1 | rev > log.tt
mapfile -t reTime < log.tt

cnt=${#reTime[@]}

declare -A reTimePath

baseP=$(pwd)


for ((j=0;j<48;j++)); do
    for ((i=0;i<cnt;i++)); do
        reTimePath[$j,$i]="${baseP}/processor${j}/${reTime[i]}"
    done
done

for ((jj=0;jj<48;jj++)); do
    for ((ii=0;ii<cnt;ii++)); do
        #  find ${retimepath[$jj,$ii]} -maxdepth 0
        #  echo "${reTimePath[$jj,$ii]}" >> log.test
        find "${reTimePath[$jj,$ii]}" -maxdepth 0 -exec rm -rf {} \;
    done
done
