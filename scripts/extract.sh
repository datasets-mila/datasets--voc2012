#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

python3 -m pip install -r scripts/requirements_extract.txt

_SNAME=$(basename "$0")

mkdir -p logs/

archives=(
	"VOCtrainval_11-May-2012.tar")

# Do not extract original-mp3.tar.gz
for archive in "${archives[@]}"
do
	jug status -- scripts/extract.py $archive --output ./
	jug execute -- scripts/extract.py $archive --output ./ \
		1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$
done

for d in VOCdevkit/VOC2012/*/
do
        printf "%s\n" "${d}"
done | sort -u | ./scripts/stats.sh
