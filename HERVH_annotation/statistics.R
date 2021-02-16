#!/usr/bin/env/Rscript

library(readr)
x <- read_tsv("HERVH.bed")

table(x$X4)

#	HERVH-int   LTR7      LTR7A     LTR7B     LTR7C     LTR7Y
#	6117      	2469        15       905       339       260


