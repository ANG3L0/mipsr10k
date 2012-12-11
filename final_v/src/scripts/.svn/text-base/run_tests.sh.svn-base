

# Setup your configuration variables
p3dir=~/470/P3ans/llvsimp4
projdir=~/Desktop/final_v/src

#run tests for golden output
echo $1
if [ "$1" = "-gen" ];
then
	cd $projdir 
	mkdir -p golden

	for file in `ls test_progs/*s | cut -d '/' -f2`;
	do
		cd $p3dir
		echo "assembling $file";
		./vs-asm $projdir/test_progs/$file > program.mem
		file=$(echo $file | cut -d'.' -f1);
		echo "run $file";
		make
		echo "copy $file.program.out";
		cp program.out $projdir/golden/$file.program.out
		echo;
		echo "copy $file.writeback.out";
		cp writeback.out $projdir/golden/$file.writeback.out
		echo;
		echo "copy $file.pipeline.out";
		cp pipeline.out $projdir/golden/$file.pipeline.out
		#grep "BUS_STORE" $projdir/golden/$file.pipeline.out | awk '{print $11,$12,$13,$14}' > $projdir/golden/$file.memsaveorder.out
		python $projdir/scripts/eolfind.py -i $projdir/golden/$file.pipeline.out | grep "BUS_STORE" > $projdir/golden/$file.memsaveorder.out
		python $projdir/scripts/eolfind.py -i $projdir/golden/$file.pipeline.out | grep 'r[0-9]\+' > $projdir/golden/$file.regorder.out
		python $projdir/scripts/eolfind.py -i $projdir/golden/$file.pipeline.out | grep ":" > $projdir/golden/$file.pcplus4order.out
		#grep "BUS_STORE" $projdir/golden/$file.pipeline.out | awk '{print $11,$12,$13,$14}' > $projdir/golden/$file.memsaveorder.out

	done
fi

# Build a fresh simv
cd $projdir #go to directory to test
mkdir -p compareOuts
mkdir -p diffOuts

for file in `ls test_progs/*s | cut -d '/' -f2`;
do
	echo "assembling $file";
	./vs-asm test_progs/$file > program.mem
	file=$(echo $file | cut -d'.' -f1);
	echo "running $file";
	make_out=$(make 2>&1) #different than &>?
	if [ $? -ne 0 ]; then
		echo "building simv failed!"
		echo "$make_out"
	fi
	echo "copying $file.program.out"
	cp program.out compareOuts/$file.program.out
	ourFileOut=$(grep @@@ compareOuts/$file.program.out)
	gFileOut=$(grep @@@ golden/$file.program.out)
	grep "BUS_STORE" mem.out | awk '{print $1,$2,$3,$4}' > compareOuts/$file.mso.out
	cp analysis.out compareOuts/$file.analysis.out
	if [ "$gFileOut" = "$ourFileOut" ]; then
		echo -e "\E[37m$file success!"; tput sgr0
	else
		echo -e "\E[31m$file failed!"; tput sgr0
		diff compareOuts/$file.program.out golden/$file.program.out | grep @@@  > diffOuts/$file.program.out_diff
	fi
	echo;
done


# Validate their output
#cd $p3dir
#cd golden
##writeback.out validation
#for file in `ls *writeback.out`;
#do
#	echo "comparing $file";
#	if [ "$(diff $p3loldir/compareOuts/$file $file)" = "" ]; then
#		echo -e "\E[37m$file successful"; tput sgr0
#	else
#		echo -e "\E[32mError in $file"; tput sgr0
#	fi
#done

#program.out validation

#cd $projdir
#cd golden
#for file in `ls *program.out`;
#do
#	echo "comparing $file";
#	goldenFileOut=$(grep @@@ $file)
#	candidateFileOut=$(grep @@@ $projdir/compareOuts/$file)
#	if [ "$goldenFileOut" = "$candidateFileOut" ]; then
#		echo -e "\E[37m$file successful"; tput sgr0
#	else
#		echo -e "\E[31mError in $file"; tput sgr0
#		#echo "diff $p3loldir/compareOuts/$file $file"
#	fi
#done
# Print the results! (different than echo file successful or not???)
