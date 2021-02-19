## EVALUATING ENHANCER OVERLAPS

library(tidyverse)
library(UpSetR)
library(RColorBrewer)



setwd("/Users/coripenrod/Documents/UNLV/Year3/HERVH_locus_analysis")

bedfile_colnames <- c("chr_1", "pos1_1", "pos2_1", "hervh_id", "num_ele", "strand",
                      "chr_2", "pos1_2", "pos2_2", "query_id")

# studies of interest:

# TOO SMALL TO BE INTERESTING
# ENdb <- read_tsv("intersections/enhancers/ENdb_enhancer_hg38_int.bed",
                 # col_names = bedfile_colnames)

jiang_TEs <- read_tsv("intersections/enhancers/jiang_et_al/TE_hg38_int.bed",
                      col_names = bedfile_colnames)
jiang_SEs <- read_tsv("intersections/Super-enhancers/jiang_et_al/SE_hg38_int.bed",
                      col_names = bedfile_colnames)

# TOO SMALL TO BE INTERESTING
# tone_COREs_h1 <- read_tsv("intersections/COREs/tonekaboni_et_al/h1_COREs_int.bed",
#                           col_names = bedfile_colnames)
# tone_COREs_h7 <- read_tsv("intersections/COREs/tonekaboni_et_al/h1_COREs_int.bed",
#                           col_names = bedfile_colnames)

# TODO: small fix of labels on barakat
barakat_naive_CSS <- 
  read_tsv("intersections/ChIP-STARR-seq/barakat_et_al/ChIP-STARR-seq_enhancers_naive_hg38_int.bed",
           col_names = c("chr_1", "pos1_1", "pos2_1", "hervh_id", "num_ele", "strand",
                         "chr_2", "pos1_2", "pos2_2", "X1","X2","X3","X4","X5","X6"))
barakat_primed_CSS <- 
  read_tsv("intersections/ChIP-STARR-seq/barakat_et_al/ChIP-STARR-seq_enhancers_primed_hg38_int.bed",
           col_names = c("chr_1", "pos1_1", "pos2_1", "hervh_id", "num_ele", "strand",
                         "chr_2", "pos1_2", "pos2_2", "X1","X2","X3","X4","X5","X6"))
barakat_naive_SE <- 
  read_tsv("intersections/Super-enhancers/barakat_et_al/Super-enhancers_naive_hg38_int.bed",
           col_names = bedfile_colnames)
barakat_primed_SE <- 
  read_tsv("intersections/Super-enhancers/barakat_et_al/Super-enhancers_primed_hg38_int.bed",
           col_names = bedfile_colnames)

# ChIP-seq
kunarso_CTCF <- read_tsv("intersections/ChIP-Seq/kunarso_et_al/CTCF_hg38_int.bed",
                         col_names = bedfile_colnames)
kunarso_NANOG <- read_tsv("intersections/ChIP-Seq/kunarso_et_al/NANOG_hg38_int.bed",
                         col_names = bedfile_colnames)
kunarso_OCT4 <- read_tsv("intersections/ChIP-Seq/kunarso_et_al/OCT4_hg38_int.bed",
                         col_names = bedfile_colnames)

# GRO-seq
GRO_seq <- read_tsv("intersections/GRO-Seq/wang_et_al_HACER/GROseq_all.bed",
                    col_names = bedfile_colnames)

# RNA-seq
lu_active_RNAseq <- read_tsv("intersections/RNA-Seq/lu_et_al/lu_coordinates_hg38_int.bed",
                          col_names = bedfile_colnames)

wang_RNAseq <- read_tsv(
  "intersections/RNA-Seq/wang_et_al/wang_coordinates_hg38_int.bed",
  col_names = c("chr_1", "pos1_1", "pos2_1", "hervh_id", "num_ele", "strand",
                "chr_2", "pos1_2", "pos2_2", "query_id", 'state'))
wang_active_RNAseq <- filter(wang_RNAseq, state == "highly")

### CREATE PLOT

listInput <- list(
                  # barakat_naive_SE = barakat_naive_SE$hervh_id,
                  # barakat_primed_SE = barakat_primed_SE$hervh_id,
                  barakat_naive_CSS = barakat_naive_CSS$hervh_id,
                  barakat_primed_CSS = barakat_primed_CSS$hervh_id,
                  jiang_TEs = jiang_TEs$hervh_id,
                  # jiang_SEs = jiang_SEs$hervh_id,
                  kunarso_NANOG = kunarso_NANOG$hervh_id,
                  # kunarso_CTCF = kunarso_CTCF$hervh_id,
                  kunarso_OCT4 = kunarso_OCT4$hervh_id,
                  GRO_seq = GRO_seq$hervh_id,
                  wang_active_RNAseq = wang_active_RNAseq$hervh_id,
                  lu_active_RNAseq = lu_active_RNAseq$hervh_id)


png("R/enhancer_meta_analysis/upset_plot.png",width = 2000, height = 1200, res = 200)
upset(fromList(listInput),
      nsets = length(listInput),
      order.by = "degree", 
      line.size = 0.5,
      sets.bar.color = brewer.pal(length(listInput),"Set2"),
      mainbar.y.label = "HERVH locus intersections",
      sets.x.label = "# HERVH loci in set",
      text.scale = c(2, 1.3, 1, 1, 2, 1)
          )
dev.off()

li <- overlapGroups(listInput, sort = T)
attr(li, "elements")[li[[12]]]




##### Extra function:
#https://github.com/hms-dbmi/UpSetR/issues/85
overlapGroups <- function (listInput, sort = TRUE) {
  # listInput could look like this:
  # $one
  # [1] "a" "b" "c" "e" "g" "h" "k" "l" "m"
  # $two
  # [1] "a" "b" "d" "e" "j"
  # $three
  # [1] "a" "e" "f" "g" "h" "i" "j" "l" "m"
  listInputmat    <- fromList(listInput) == 1
  #     one   two three
  # a  TRUE  TRUE  TRUE
  # b  TRUE  TRUE FALSE
  #...
  # condensing matrix to unique combinations elements
  listInputunique <- unique(listInputmat)
  grouplist <- list()
  # going through all unique combinations and collect elements for each in a list
  for (i in 1:nrow(listInputunique)) {
    currentRow <- listInputunique[i,]
    myelements <- which(apply(listInputmat,1,function(x) all(x == currentRow)))
    attr(myelements, "groups") <- currentRow
    grouplist[[paste(colnames(listInputunique)[currentRow], collapse = ":")]] <- myelements
    myelements
    # attr(,"groups")
    #   one   two three 
    # FALSE FALSE  TRUE 
    #  f  i 
    # 12 13 
  }
  if (sort) {
    grouplist <- grouplist[order(sapply(grouplist, function(x) length(x)), decreasing = TRUE)]
  }
  attr(grouplist, "elements") <- unique(unlist(listInput))
  return(grouplist)
  # save element list to facilitate access using an index in case rownames are not named
}

