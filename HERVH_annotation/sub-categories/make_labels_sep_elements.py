#!/usr/bin/env python

#  ../HERVH.bed
#chr1    787351    787718    LTR7    2003    +
#chr1    1469768    1470201    LTR7B    3482    +
#chr1    1470858    1471236    LTR7    1862    +


outfile = open("HERVH_sub-label.bed",'w')

counter = 1
with open("../HERVH.bed",'r') as infile:
	for line in infile:
		ll = line.strip().split()
		ll[3] = ll[3] + ':' + str(counter)
		counter += 1

		outfile.write("\t".join(ll) + '\n')

outfile.close()

