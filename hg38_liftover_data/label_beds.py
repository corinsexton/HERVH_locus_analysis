#!/usr/bin/python
import glob

for i in glob.glob("*/*/*bed"):
	infile = open(i,'r')
	outfile = open(i + '_lab', 'w')
	counter = 1
	for line in infile:
		ll = line.strip().split('\t')

		if len(ll) > 3:
			break
		else:
			label = i.split("/")[-1]
			ll.append(label.replace('.bed','') + '_' + str(counter))

			outfile.write("\t".join(ll) + '\n')
			counter += 1
			


	infile.close()
			
