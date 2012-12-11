#!/usr/bin/python
import os
import sys, getopt
import re
from shutil import copyfile

def main(argv):
	inputfile=''
	outputfile=''
	inarg=''
	outarg=''
	mode=''
	try:
		opts,args = getopt.getopt(argv, "hi:o:m:")
	except getopt.GetoptError:
		print "tbgen.py -i [module.v] -o [templatefile.tgt]"
		print "then do:"
		print "tbgen.py -i [templatefile.tgt] -o [testbench_name.v] -m [modename]"
		print "modename can be fl or mt or rob or rs.  Will generate appropriate table.  If modename is blank and you only have -m then you can put your own printy thing out yourself in testbench"
		sys.exit(2)
	if (len(opts)>4 and len(opts)<2):
		print "Please do tbgen.py -h for more information."
		sys.exit(2)
	for opt, arg in opts:
		if (opt=="-h"):
			print "Usage: \n\ttbgen.py -i [module.v] -o [templatefile.tgt] \n\tThis creates a stub templatefile.tgt from the module.v \nThen do: \n\ttbgen.py -i [templatefile.tgt] -o [testbench_name.v] \n\tThis will create a testbench file from the template file"
			sys.exit(2)
		if (opt=="-i"):
			suffix=re.findall('.*\.(v|tgt)',arg)
			#print suffix
			if (suffix==""):
				print "Output file must be a .v file (generated test template) or a .tgt file (test template file)"
			inarg=opt
			inputfile=arg
		if (opt=="-o"):
			#suffix=re.search('\..*',arg)
			suffix=re.findall('.*\.(v|tgt)',arg)
			#print suffix
			if (suffix==""):
				print "Output file must be a .v file (generated test template) or a .tgt file (test template file)"
				sys.exit(2)
			outarg=opt
			outputfile=arg
		if (opt=="-m"):
			mode = arg
		#print arg + " " + opt

	if (inputfile[-1]=="v" and outputfile[-3:]!="tgt"):
		print "If input is .v (module), output must be .tgt (stub test template)"
		sys.exit(2)

	if (inputfile[-3:]=="tgt" and outputfile[-1]!="v"):
		print "If input file is .tgt (test template file), output file must be .v (generated testbench)"
		sys.exit(2)
    
	processfile(inputfile,outputfile,mode)
    
def processfile(inputfile, outputfile,mode):
	if (inputfile[-1]=="v"):
		generateTestStub(inputfile,outputfile)
	else:
		#means input file is .tgt, generate a testbench
		generateTestbench(inputfile,outputfile,mode)


def generateTestStub(inputfile,outputfile):
	#read inputfile
	f=open(inputfile,'r')
	pornumlist=[]
	outpornlist=[]
	inputwirelist=[]
	outputwirelist=[]
	mname='init'
	while (True):
		a=f.readline();
		if (a==''):
			break
		modulename = re.findall('module\s+([^\s]+).*\(',a)
		if (modulename!=[]):
			mname = modulename[0]
		if (re.findall('//.*input.*;\s+',a)==[]):
			inputline = re.findall('.*(input.*;)',a)
		else:
			inputline=[]

		if (re.findall('//.*output.*;\s+',a)==[]):
			outputline = re.findall('.*(output.*;)',a)
		else:
			outputline = []

		if (inputline!=[]):
			#print inputline[0]
			portnum = re.findall('\[.*\:.*\]',inputline[0])
			wire = re.findall('\s+(\w.*);',inputline[0])
			if (wire==[]):
				#in case there is no space between [2:0]wirename;
				wire = re.findall('\](\w.*);',inputline[0])
			#print wire[0]
			if (wire[0]!="clock"):
				#only append if it isn't clock: clock is auto-generated in writing script
				if (portnum!=[]):	
					pornumlist.append(portnum[0])
					#print portnum[0]
				else:
					pornumlist.append('(one wire)')
				inputwirelist.append(wire[0])
		if (outputline!=[]):
			portnum = re.findall('\[.*\:.*\]',outputline[0])
			wire = re.findall('\s+(\w[^\s]+);',outputline[0])
			if (wire==[]):
				wire = re.findall('\](\w[^\s]+);',outputline[0])
			if (portnum!=[]):
				outpornlist.append(portnum[0])
				#print portnum[0]
			else:
				outpornlist.append('(one wire)')
			outputwirelist.append(wire[0])
			#print wire[0]
	#print mname
	f.close()
	if (os.path.isfile(outputfile)):
		copyfile(outputfile,outputfile+".bak")
	f=open(outputfile,'w')
	#write to output file
	f.write("----------------------------------------------------------------------------------------------------------------------------------------\n")
	f.write("How to use: for the input port stubs, write in this format:\n\
			wire     [a:b]: signal@0,0 signal@1,1 signal@5,5 etc.\n\
			signal@0 is signal before first negedge. Number after signal indicates the absolute clock #, example:\n\
			a (one wire): 1,0 0,3 1,4 will translate to:\n\
			a=1 //a initialized to 1\n\
			@(negedge clock)\n\
			a=1\n\
			@(negedge clock)\n\
			a=1\n\
			@(negedge clock)\n\
			a=0 //0 after 3 negedges\n\
			@(negedge clock)\n\
			a=1 //1 after 4 negedges\n")
	f.write("-----------------------------------------------------------------------------------------------------------------------------------------\n\n")
	f.write("MODULENAME: " + "@@@"+mname+"@@@" + "\tDo not edit, for internal state\n")
	f.write("@@@inputs@@@ (all lines above this is ignored):\n")
	for i in range(0,len(inputwirelist)):
		f.write("@"+inputwirelist[i] + "\t" + pornumlist[i]+":\n")
	f.write("\n")
	f.write("@@@outputs@@@ (all lines below this is ignored, DO NOT EDIT used for internal state)\n")
	for i in range(0,len(outputwirelist)):
		f.write("@"+outputwirelist[i] + "\t" + outpornlist[i]+":\n")
	f.close()

def generateTestbench(inputfile,outputfile,mode):
	r=open(inputfile,'r')
	w=open(outputfile,'w')
	mname='init'
	allInputs={} #{input name: {clock0: signal, clock1: signal, etc}}
	inputDict={}
	allInputPorts={}
	#print out preamble stuff
	w.write("`timescale 1ns/100ps\n")
	w.write("module testbench;\n")
	while(True):
		a=r.readline()
		modulename=re.findall('MODULENAME.*@@@(.*)@@@',a)
		if (modulename!=[]):
			mname=modulename[0]
		if(a==''):
			break
		start=re.findall('@@@inputs@@@',a)
		if (start!=[]):
			#start the parsing of inputs
			break
	pornamelist=[]
	widelist=[]
	max=0
	#gather all input/data
	while(True):
		a=r.readline()
		if (a=='' or a[0:3]=="@@@"):
			#break EOF (shouldn't happen but never want inf loop) or output section reached.
			break
		input=re.findall('@(\w+)\s',a)
		clock=re.findall(',([0-9]+)\s+',a)
		signal=re.findall('\s+([^\s:\[]+),[0-9]+',a)
		if (input!=[]):
			#new input
			inputDict={}
			for i in range(len(clock)):
				inputDict[int(clock[i])]=signal[i]
				if (int(clock[i])>max):
					max = int(clock[i])
			allInputs[input[0]]=inputDict
			wir=re.findall('\[.*\:.*\]',a)
			currInput=input[0]
			if (wir!=[]):
				allInputPorts[currInput]="\t"+wir[0]
			else:
				allInputPorts[currInput]="\t"
			#print clock
			#print signal
			#print input
		else:
			if (clock!=[]):
				#keep parsing current input
				for i in range(len(clock)):
					inputDict[int(clock[i])]=signal[i]
					if (int(clock[i])>max):
						max=int(clock[i])
				print ""
			allInputs[currInput]=inputDict
	#read the outputs
	outPorts={}
	while(True):
		a=r.readline()
		if(a==''):
			break
		output=re.findall('@(\w+)\s+',a)
		wir=re.findall('\[[0-9]+:[0-9]+\]',a)
		if (output!=[]):
			if (wir!=[]):
				outPorts[output[0]]="\t"+wir[0]
			else:
				outPorts[output[0]]="\t"
	#print allInputs['reset']
	#print allInputs['mt_T1A']
	#print allInputs['mt_T2A']
	#print allInputs['mt_T1B']
	#print max
	#start printing stuff
	#print allInputPorts
	wirenames=allInputs.keys()
	wirenames.sort() #alpha order
	outwirenames=outPorts.keys()
	outwirenames.sort()
	wirenamesMinusLast=outwirenames[0:-1] #to exclude last input (it can't have a comma)
	w.write("///////// INPUTS //////////\nreg clock;\n")
	for inputname in wirenames:
		w.write("reg"+allInputPorts[inputname]+"\t"+inputname+";\n")
	w.write("///////// OUTPUTS //////////\n")
	for outname in outwirenames:
		w.write("wire"+outPorts[outname]+"\t"+outname+";\n")

	w.write("\n\n"+mname + "   " + mname + "_0" + "(\n")
	w.write("\t//input ports\n\t.clock(clock),\n")
	for name in wirenames:
		w.write("\t."+name+"("+name+"),\n")
	w.write("\t//output ports\n")
	for oname in wirenamesMinusLast:
		w.write("\t."+oname+"("+oname+"),\n")
	w.write("\t."+outwirenames[-1]+"("+outwirenames[-1]+")\n")
	w.write(");\n\n\n")
	w.write("always\n\tbegin\n\t#(`VERILOG_CLOCK_PERIOD/2);\n\tclock=~clock;\nend\n\n")
	w.write("reg [19:0] clocks;\nreg [10:0] i;\nalways @(posedge clock)\nbegin\n\tclocks=clocks+1;\n\t$display(\"POSEDGE %20d:\", clocks);\n")
	print mode
	if (mode=='fl'):
		w.write("$display(\"freelist_TA:%6d \\t freelist_TB:%6d \\t full:%1b \\t empty:%1b \\t almost_empty:%1b\", fl_TA,fl_TB,full,empty,almost_empty);\n\
`ifdef DEBUG_OUT\n\
  $display(\"------------------------------------------\");\n\
  $display(\"|    ht pos \\t | \\t PR# \\t \\t |\\n\\\n\
------------------------------------------\");\n\
  for (i=0;i<64;i=i+1) begin\n\
    if (freelist_0.head==i && freelist_0.tail==i) begin\n\
    $display(\"| \\t ht \\t | \\t %6d \\t |\",\n\
        freelist_0.freelist[i]);\n\
    end\n\
    else if (freelist_0.head==i) begin\n\
    $display(\"| \\t h \\t | \\t %6d \\t |\",\n\
        freelist_0.freelist[i]);\n\
    end\n\
    else if (freelist_0.tail==i) begin\n\
    $display(\"| \\t t \\t | \\t %6d \\t |\",\n\
        freelist_0.freelist[i]);\n\
    end\n\
    else begin\n\
    $display(\"| \\t   \\t | \\t %6d \\t |\",\n\
        freelist_0.freelist[i]);\n\
    end\n\
  end\n\
  $display(\"------------------------------------------\\n\");\n\
`endif\nend\n\n\n")
	if (mode=='rob'):
		print 1
	if (mode=='rs'):
		print 2
	
	#sort the clocks in allInputs
	sortedClocks={}
	for input in wirenames:
		sortedClocks[input]=allInputs[input].keys() #ex: {input: [0, 1, 15]} input, array of clocks is values
		sortedClocks[input].sort()
	#print sortedClocks
	#print allInputs
	#begin actually printing the test
	w.write("initial\nbegin\nclock=0;\nclocks=0;\n")
	for i in range(0,max+1):
		ksort = sortedClocks.keys()
		ksort.sort()
		for input in ksort:
			if (sortedClocks[input]!=[]):
				#there is no value for this clock, if we don't assign anything the value will remain the same
				if (sortedClocks[input][0]==i):
					w.write(input+"="+allInputs[input][i]+";\n")
					sortedClocks[input].pop(0)
		w.write("@(negedge clock)  //end of clock " + str(i) + " \n")
	w.write("\n\n")
	w.write("$finish;\n")
	w.write("end //end initial")
	w.write("\nendmodule")



	#print mname	
	w.close()
	r.close()

if __name__ == '__main__':
	main(sys.argv[1:])
