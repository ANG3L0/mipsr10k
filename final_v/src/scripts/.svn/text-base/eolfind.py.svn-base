import re
import sys, getopt
import os

def main(argv):
	inputfile=''
	try:
		opts, args = getopt.getopt(argv, "i:")
	except getopt.GetoptError:
		print "error"
	for opt, arg in opts:
		if (opt=="-i"):
			inputfile=arg
	
	pipeopen = open(inputfile)
	while (True):
		p = pipeopen.readline()
		if (p==''):
			break
		else:
			busstore = re.findall('(BUS_STORE.*)$',p)
			regstore = re.findall('(r[0-9]+.*?)\s',p)
			pcorder = re.findall('(\w+:\w+)',p[0:20])
			if (busstore!=[]):
				print busstore[0]
			if (regstore!=[]):
				print regstore[0]
			if (pcorder!=[]):
				print pcorder[0]


if __name__ == '__main__':
	main(sys.argv[1:])
