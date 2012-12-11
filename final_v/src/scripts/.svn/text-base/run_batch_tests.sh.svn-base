#!/bin/bash
p3dir=~/470/P3ans/llvsimp4
projdir=~/Desktop/final_v/src

cd $projdir
mkdir -p batch_runs/
for i in {1..20}
do
	echo "run $i running..."
	sed -i "s/MEM_LATENCY_IN_CYCLES\s*[0-9]*/MEM_LATENCY_IN_CYCLES $i/g" $projdir/sys_defs.vh
	timeout 500 ./scripts/run_tests.sh > batch_runs/run$i.txt #timeout after 500 seconds
	exitcode=$?
	echo "exit code is: $exitcode"
	if [ "$exitcode" = "0" ]; 
	then
		failstring=$(grep "fail" $projdir/batch_runs/run$i.txt)
		if [ "$failstring" = "" ]; then
			echo "run $i success!"; tput sgr0
		else
			echo "run $i failed!"; tput sgr0
			#killnums=$(ps aux | grep simv | awk {'print $2'})
			#kill -9 $killnums
		fi
	else
		echo "run $i failed!"; tput sgr0
	fi
	sleep 10;
done
