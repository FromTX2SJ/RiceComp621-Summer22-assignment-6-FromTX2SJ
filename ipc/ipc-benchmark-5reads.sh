#!/bin/bash
# Eric Schumacker, eds6@rice.edu, SUID S01340401
# Utility to perform benchmarking for 

buf_range_idx=24

#Configure the kernel per-socket buffer size
sudo sysctl -w net.core.rmem_max=33554432
sudo sysctl -w net.core.rmem_default=33554432

#2thread, pipe
out="2thread-pipe-read_counts.txt"
for (( i=0; i < buf_range_idx; i++ ))
do
    echo $((2 ** i)) >> $out
    sudo bpftrace -c "./ipc-static -i pipe -b $((2 ** i)) 2thread" -e "tracepoint:syscalls:sys_enter_read {@[comm] = count();}" >> $out
done

#2thread, socket
#out="2thread-socket-local-reads.txt"
#for (( i=0; i < buf_range_idx; i++ ))
#do
#    echo $((2 ** i)) > out
#    sudo bpftrace -c ./ipc-static -i local -b $((2 ** i)) 2thread -e tracepoint:syscalls:sys_exit_read {@[comm] = hist(args->ret);} >> $out
#done

#2thread, socket -s
#out="2thread-socket-local-s-reads.txt"
#for (( i=0; i < buf_range_idx; i++ ))
#do
#    echo $((2 ** i)) > out
#    sudo bpftrace -c './ipc-static -i local -b $((2 ** i)) -s 2thread' -e 'tracepoint:syscalls:sys_exit_read {@[comm] = hist(args->ret);}' >> $out
#done

