#!/share/apps/R/R-3.5.1/bin/Rscript

library(readr)

args = commandArgs(trailingOnly=TRUE)

ctcf <- read_tsv(args[1], col_names = F)
ctcf$X3 <- ctcf$X2 + 1
write_tsv(ctcf,args[2], col_names = F)
