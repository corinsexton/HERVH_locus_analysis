#!/bin/bash

find . -name 'stats.txt' -exec rm {} \;

for bed in $(find ../hg38_liftover_data -name "*.bed"); do

	bed_lab=${bed#../hg38_liftover_data/}
	bed_lab=${bed_lab%.bed}
	#echo $bed

	echo $bed_lab

	# -u only report at most 1 overlap for a
	bedtools intersect -a ../HERVH_annotated.bed -b $bed -wa -wb > ${bed_lab}_int.bed

	# grab original wc
	orig_count=$(cat $bed | wc -l)

	HERVH_count=$(cut -f4 ${bed_lab}_int.bed | sort | uniq | wc -l)
	Query_count=$(cut -f10 ${bed_lab}_int.bed | sort | uniq | wc -l)
	total=$(cat ${bed_lab}_int.bed | wc -l)

	stats=${bed_lab%/*}/stats.txt

	echo >> $stats
	echo ${bed_lab#*/} >> $stats
	echo >> $stats
	echo "Original Count: $orig_count" >> $stats
	echo "HERVH Count: $HERVH_count" >> $stats
	echo "Query Count: $Query_count" >> $stats
	echo >> $stats
	echo "Total Intersections: $total" >> $stats
	echo >> $stats
	echo >> $stats


done
