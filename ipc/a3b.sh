#!/bin/bash
# Script written by Bryan Boone.
# Uses the modified version of ipc.c called ipc-csv.c.

subdirectory=a3b
output=a3b
printf "start\n\n"
thread_modes=("2thread" "2proc")
ipc_types=("pipe" "local" "tcp")
pmc_modes=("l1d" "l1i" "l2")


for t in "${thread_modes[@]}";
do
	for i in "${ipc_types[@]}";
	do
		for p in "${pmc_modes[@]}";
		do
			header=$(./ipc-static $t -i $i -P $p)
			outfile=$(echo $output"/"$t"_"$i"_"$p"_"$output".csv" | tr -d ' ')
			#echo $outfile
			#echo $header > $outfile
			for buffer in {0..24};
			do
				let bufter=2**$buffer
				echo -ne $t $i $p $((100*(buffer-10)/14))' \r'
				outvalue=$(./ipc-static $t -i $i -P $p -b $bufter)
				echo $outvalue >> $outfile
			done
		done
	done
done
