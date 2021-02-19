
library(tidyverse)
setwd("/Users/coripenrod/Documents/UNLV/Year3/HERVH_locus_analysis")

hervh_annotation <- read_tsv("HERVH_annotated.bed", col_names = F)

colnames(hervh_annotation) <- c("chr", "pos1", "pos2", "label", "num_ele", "strand")
hervh_annotation <- hervh_annotation %>% separate(label,
                                                  into = c("type", "elements","id","LTR_loc"),
                                                  sep = ':',remove = F)

hervh_annotation$type <- factor(hervh_annotation$type, levels = c("solo","flanked", "nonflanked"))

# could I pool and scale expression values from all epiblast cells for every element?
# currently only have HERVH full-length element data, not solo LTRs


# HOW TO DETECT POSITIONAL ENRICHMENT ACROSS CHROMOSOMES
# POTENTIALLY ENRICHED ON SEX CHROMOSOMES

num_elements_per_chrom <- data.frame(table(hervh_annotation[!grepl("_",hervh_annotation$chr),]$chr))
colnames(num_elements_per_chrom) <- c("chr","freq")

chr_sizes <- read_tsv("util/hg38.chrom.sizes", col_names = c("chr","chr_size"))
scaled_presence <- merge(num_elements_per_chrom,chr_sizes,by = 'chr') %>% mutate(perc = freq/chr_size * 10e5)


###

ggplot(hervh_annotation, aes(x = type, fill = type)) +
  geom_bar() + 
  labs(title = "Annotated HERVH/LTR7 types") +
  theme_minimal() +
  theme(legend.position = "none")

