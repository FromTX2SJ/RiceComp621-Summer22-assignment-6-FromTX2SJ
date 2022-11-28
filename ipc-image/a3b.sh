#!/bin/bash
# Script written by Bryan Boone.
# Uses the modified version of ipc.c called ipc-csv.c.

subdirectory=a3b
output=a3b
printf "start\n\n"
thread_modes=("2thread" "2proc")
ipc_types=("pipe" "local" "tcp")


for t in "${thread_modes[@]}";
do
	for i in "${ipc_types[@]}";
	do
		outfile=$(echo $output"/"$t"_"$i"_"$output".csv" | tr -d ' ')
		#echo $outfile
		for buffer in {0..24};
		do
			let bufter=2**$buffer
			echo -ne $t $i $((100*(buffer/25)))' \r'
			outvalue=$(./ipc-static $t -i $i -b $bufter)
			echo $outvalue >> $outfile
		done
	done
done
