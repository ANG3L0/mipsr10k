import random
import string
import shlex
import re
import sys, getopt
from tempfile import mkstemp
from shutil import move
from os import remove, close

if __name__ == '__main__':
	mainargs = sys.argv[1:]
	outputfile = ''
	#get the outputfile name
	try:
		opts,args = getopt.getopt(mainargs,"o:")
	except getopt.GetoptError:
		sys.exit(2)
	for opt, arg in opts:
		if (opt=="-o"):
			outputfile = arg
	f = open(outputfile,'w')
	#knob parameters
	prob = {}
	#probability of certain instr.
	prob["halt"] = 0.001
	prob["addq"] = .2
	prob["subq"] = .2
	prob["mulq"] = .2
	prob["ldq"] = .3
	prob["stq"] = .3
	prob["br"] = .05
	prob["beq"] = .05
	prob["ret"] = .05
	prob["bsr"] = .05
	labelprob = .05
	addrnum = 15 # num unique addr in program.
	proglength = 100 #program line numbers
	ldalength = 10 #how many ldas
	regnum = 10 #how many unique registers, discounting special regs
	addrstrarray=[]
	regstrarray=[]
	braddrarray=[]
	labelarray=[]

	#create random register #s and addresses
	for i in range(regnum):
		regstrarray.append("$r"+str(i))
	for i2 in range(addrnum):
		lst = [random.choice(string.hexdigits) for n in xrange(2)]
		hexstr = "".join(lst)
		hexstr = hexstr.lower()
		addrstrarray.append("0x1"+hexstr+"0")

	#lda to randomly load registers.
	for i in range(ldalength):
		lst = [random.choice(string.hexdigits) for n in xrange(4)] #16 bit random data, 4-bit wide hex
		hexstr = "".join(lst)
		hexstr = hexstr.lower()
		f.write("\t\tlda\t"+"$r"+str(i)+", "+"0x"+hexstr+"\n");

	labelnum=0
	#choose instructions
	for i in range(proglength):
		#while loop chooses instruction
		noLabel = True
		while (True):
			randInst = random.randint(0,len(prob.keys())-1)
			randInst = prob.keys()[randInst]
			randInstProb = prob[randInst]
			if (random.random() <= randInstProb):
				break #instruction chosen, break out of while loop
		#choose src/dest regs.
		regsrc1 = random.randint(0,len(regstrarray)-1)
		regsrc1 = regstrarray[regsrc1]
		regsrc2 = random.randint(0,len(regstrarray)-1)
		regsrc2 = regstrarray[regsrc2]
		regdest = random.randint(0,len(regstrarray)-1)
		regdest = regstrarray[regdest]
		#randomly inject labels to branch to
		if (random.random() <= labelprob):
			labelstr = "label"+str(labelnum)+":"
			labelarray.append(labelstr)
			labelnum = labelnum + 1
			noLabel = False

		#arithmetic instr.
		if (randInst is "addq" or randInst is "subq" or randInst is "mulq"):
			if (noLabel):
				f.write("\t\t"+randInst+"\t"+regsrc1+", "+regsrc2+", "+regdest+"\n");
			else:
				f.write(labelstr+"\t\t"+randInst+"\t"+regsrc1+", "+regsrc2+", "+regdest+"\n");
		#ldq instr
		if (randInst is "ldq"):
			addrnum = random.randint(0,len(addrstrarray)-1)
			addrnum = addrstrarray[addrnum]
			if (noLabel):
				f.write("\t\t"+randInst+"\t"+regdest+", "+addrnum+"($r31)"+"\n");
			else:
				f.write(labelstr+"\t\t"+randInst+"\t"+regdest+", "+addrnum+"($r31)"+"\n");
		#stq instr
		if (randInst is "stq"):
			addrnum = random.randint(0,len(addrstrarray)-1)
			addrnum = addrstrarray[addrnum]
			if (noLabel):
				f.write("\t\t"+randInst+"\t"+regsrc1+", "+addrnum+"($r31)"+"\n");
			else:
				f.write(labelstr+"\t\t"+randInst+"\t"+regsrc1+", "+addrnum+"($r31)"+"\n");
		#halt inst
		if (randInst is "halt"):
			f.write("\t\tcall_pal 0x555\n")
		####################### branches ######################
		#br instr
		if (randInst is "br" and labelarray!=[]):
			f.write("brtag"+"\n");
		#beq instr
		if (randInst is "beq" and labelarray!=[]):
			f.write("beqtag"+"\n");
		#ret instr
		if (randInst is "ret" and labelarray!=[]):
			f.write("rettag"+"\n");
		#bsr instr
		if (randInst is "bsr" and labelarray!=[]):
			f.write("bsrtag"+"\n");
	f.close()
	#fill in branch instructions.
	#replace all brs
	f = open (outputfile)
	if (labelarray!=[]): #there are actually labels to branch to
		fh, abs_path = mkstemp()
		new_file = open(abs_path,'w')
		bsrfound = False
		for line in f:
			if "brtag" in line:
				jumplabel=random.randint(0,len(labelarray)-1)
				jumplabel=labelarray[jumplabel]
				subst="\t\tbr\t"+jumplabel[0:-1]
				new_file.write(line.replace("brtag",subst))
			elif "beqtag" in line:
				jumplabel=random.randint(0,len(labelarray)-1)
				jumplabel=labelarray[jumplabel]
				regsrc1 = random.randint(0,len(regstrarray)-1)
				regsrc1 = regstrarray[regsrc1]
				subst="\t\tbeq\t"+regsrc1+", "+jumplabel[0:-1]
				new_file.write(line.replace("beqtag",subst))
			elif "rettag" in line:
				if (bsrfound):
					regsrc1 = random.randint(0,len(regstrarray)-1)
					regsrc1 = regstrarray[regsrc1]
					if (random.random()<=.5):
						subst="\t\tret"
						new_file.write(line.replace("rettag",subst))
					else:
						subst="\t\tret"+"\t"+regsrc1
						new_file.write(line.replace("rettag",subst))
			elif "bsrtag" in line:
				jumplabel=random.randint(0,len(labelarray)-1)
				jumplabel=labelarray[jumplabel]
				subst="\t\tbsr\t"+"$r26, "+jumplabel[0:-1]
				new_file.write(line.replace("bsrtag",subst))
				bsrfound = True
			else:
				new_file.write(line.replace("brtag", "brtagerr"))
		new_file.close()
		close(fh)
		f.close()
		remove(outputfile)
		move(abs_path,outputfile)





#thanks, stackoverflow.
def replace(file, pattern, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    new_file = open(abs_path,'w')
    old_file = open(file)
    for line in old_file:
        new_file.write(line.replace(pattern, subst))
    #close temp file
    new_file.close()
    close(fh)
    old_file.close()
    #Remove original file
    remove(file)
    #Move new file
    move(abs_path, file)