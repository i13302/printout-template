#!/bin/bash

#--
# echo $1 # work dir
# echo $2 # html dir
# echo $3 # pdf dir
# echo $4 # i13302/printout
# echo $5 # TZ
#--

cd $1

pids=()
for hf in `ls $2/*.html`
do
	pf="$3/"$( echo `basename $hf` | sed 's/\.html/\.pdf/')
	docker run --rm $5 --volume "$(pwd):/data" $4 $hf $pf &
	pids+=( "$!" )
done

for pid in "${pids[@]}"
do
	wait $pid
done
