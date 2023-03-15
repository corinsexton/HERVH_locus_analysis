#!/usr/bin/python

outfile = open("HERVH_rename.tsv",'w')
outfile_key = open("HERVH_subelements_key.tsv",'w')
files = ["HERVH_soloLTRs.bed","HERVH_solo_HERVHint.bed", "HERVH_flankLTRs.bed", "HERVH_nonflankingLTRS.bed"]
labels = ['solo', 'solo','flanked','nonflanked']

counter = 1
for i in range(len(files)):
	infile = open(files[i],'r')

	master_label = labels[i]

	#chr10    124800426    124800816    1    LTR7:1068    +
	#chr10    130487052    130487525    1    LTR7C:1069    +
	#chr10    131050053    131050303    2    LTR7B:1070,LTR7B:1071    +

	count_labs = 0
	for line in infile:
		ll = line.strip().split('\t')

		lab2 = ''
		strand = ll[5]

		if i == 3: # nonflanked
			labs = ll[4].split(',')

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


		labs_colon = ll[4].split(',')
	

		# for master label
		labs = [ x[:x.index(':')] for x in labs_colon ]
				
		labs = sorted(list(set(labs)), reverse = True)
		
		if lab2 != '':
			final_lab = master_label + ':' + '_'.join(labs) + ':' + str(counter) + ":" + lab2
			#final_lab = master_label + ':' + str(counter) + ":" + lab2
		else:
			final_lab = master_label + ':' + '_'.join(labs) + ':' + str(counter)
			#final_lab = master_label + ':' + str(counter)
	

		# for key
		if i in [0,1]: #solo loci 
			for l in labs_colon:
				outfile_key.write(final_lab + '\t' + l + '\tNA\n')

		else: # flanked and nonflanking loci
			if strand == '+':
				ltr_lab = '5prime' # start on 5prime end
				for l in labs_colon:
					if 'HERVH-int' in l:
						ltr_lab = '3prime'
						outfile_key.write(final_lab + '\t' + l + '\tNA\n')
					if 'LTR' in l:
						outfile_key.write(final_lab + '\t' + l + '\t' + ltr_lab + '\n')
						
			if strand == '-':
				ltr_lab = '3prime' # start on 5prime end
				for l in labs_colon:
					if 'HERVH-int' in l:
						ltr_lab = '5prime'
						outfile_key.write(final_lab + '\t' + l + '\tNA\n')
					if 'LTR' in l:
						outfile_key.write(final_lab + '\t' + l + '\t' + ltr_lab + '\n')
				

		outfile.write(line.strip() + "\t" + final_lab + '\n')
		counter += 1

	infile.close()
	
outfile.close()
outfile_key.close()
