#!/bin/bash

for i in */*/*bed; do

	orig=$(cat $i | wc -l)
	lab=$(cat ${i}_lab | wc -l)

	if (( $orig == $lab )); then
		mv ${i}_lab ${i}
	fi

done
