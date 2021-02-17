#!/usr/bin/python

outfile = open("HERVH_rename.tsv",'w')
files = ["HERVH_soloLTRs.bed","HERVH_solo_HERVHint.bed", "HERVH_flankLTRs.bed", "HERVH_nonflankingLTRS.bed"]
labels = ['solo', 'solo','flanked','nonflanked']

counter = 1
for i in range(len(files)):
	infile = open(files[i],'r')

	master_label = labels[i]

		

	for line in infile:
		ll = line.strip().split('\t')
		lab2 = ''

		if i == 3: # nonflanked
			labs = ll[4].split(',')
			strand = ll[5]

			left = False
			right = False


			if 'LTR' in labs[0]:
				left = True
			elif 'LTR' in labs[-1]:
				right = True
			else:
				print line
				print("IN MIDDLE")


			if strand == '+':
				if left: lab2 = '5prime'
				elif right: lab2 = '3prime'
			else:
				if left: lab2 = '3prime'
				elif right: lab2 = '5prime'

				
		labs = sorted(list(set(ll[4].split(','))), reverse = True)
		
		if lab2 != '':
			final_lab = master_label + ':' + '_'.join(labs) + ':' + str(counter) + ":" + lab2
		else:
			final_lab = master_label + ':' + '_'.join(labs) + ':' + str(counter)

		outfile.write(line.strip() + "\t" + final_lab + '\n')
		counter += 1

	infile.close()
	
outfile.close()

