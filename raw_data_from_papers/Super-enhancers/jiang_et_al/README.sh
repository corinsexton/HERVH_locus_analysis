#!/bin/bash
# annotations of all cell types
# super enhancers, traditional enhancers, super enhancer elements
#
#wget http://www.licpathway.net/sedb/download/package/SE_package.bed
#wget http://www.licpathway.net/sedb/download/package/TE_package.bed

##wget http://www.licpathway.net/sedb/download/package/SE_ele_package.bed
##  elements are a subset of SE, SE covers large region. One SE could have 10 SE-elements


# filter file
#grep -i 'stem cell' SEdb_attributes.tsv | grep -i 'embryo' | cut -f1 > samples_from_stem_cell.txt

grep -f samples_from_stem_cell.txt SE_package.bed > SE_stemcell.bed
grep -f samples_from_stem_cell.txt TE_package.bed > TE_stemcell.bed


cut -f 1,2,3,5 TE_package.bed > TE_hg19.bed
awk '{print $3"\t"$4"\t"$5"\t"$1}' SE_package.bed > SE_hg19.bed


../../../util/liftOver TE_hg19.bed ../../../util/hg19ToHg38.over.chain.gz ../../../hg38_liftover_data/enhancers/jiang_et_al/TE_hg38.bed z
../../../util/liftOver SE_hg19.bed ../../../util/hg19ToHg38.over.chain.gz ../../../hg38_liftover_data/Super-enhancers/jiang_et_al/SE_hg38.bed z


