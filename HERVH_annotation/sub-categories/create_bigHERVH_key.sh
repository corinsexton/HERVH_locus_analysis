#!/bin/bash



#grep 'HERVH-int' rmsk_hg38.bed > HERVH.bed
#grep -E 'LTR7[YBCA]?\s' rmsk_hg38.bed >> HERVH.bed
#
#bedtools sort -i HERVH.bed > s_HERVH.bed
#mv s_HERVH.bed HERVH.bed

bedtools merge -i HERVH_sub-label.bed -d 9000 -c 4,4,6 -s -o count,collapse,distinct > HERVH_within9kb.bed



# no solo LTRS
grep "HERVH" HERVH_within9kb.bed > HERVH_noSoloLTRS.bed

# only solo LTRs
sort HERVH_within9kb.bed  HERVH_noSoloLTRS.bed | uniq -u > HERVH_soloLTRs.bed

# flanking and not LTRs
grep -E "LTR7[YBCA]?.*HERVH-int.*LTR7[YBCA]?" HERVH_noSoloLTRS.bed > HERVH_flankLTRs.bed
sort HERVH_noSoloLTRS.bed  HERVH_flankLTRs.bed | uniq -u > HERVH_nonflankLTRs.bed

# solo HERVH-int and nonflanking LTRs.
grep -v 'LTR7' HERVH_nonflankLTRs.bed > HERVH_solo_HERVHint.bed
grep 'LTR7' HERVH_nonflankLTRs.bed > HERVH_nonflankingLTRS.bed



# 2,620 total elements:

### FINAL FILES:

# - HERVH_soloLTRs.bed  		(1290) ## JUST LTRs
# - HERVH_solo_HERVHint.bed		(29)   ## JUST HERVH-int

# - HERVH_flankLTRs.bed			(1048) ## 2+ LTRs surrounding at least one HERVH
# - HERVH_nonflankingLTRS.bed	(253)  ## LTRs not surrounding HERVH-int (one on either 5' or 3')



./make_key.py # which outputs HERVH_rename.tsv

# edit with vim 98080082 label as middle (nonflanking that's not 5 or 3 prime)

# convert ot bedfile

# cols = chr  pos1  pos2  label  num_elements  strand
awk '{print $1"\t"$2"\t"$3"\t"$7"\t"$4"\t"$6}' HERVH_rename.tsv > HERVH_final.bed

awk '{print $7"\t"$5}' HERVH_rename.tsv > HERVH_subelements_key.tsv
