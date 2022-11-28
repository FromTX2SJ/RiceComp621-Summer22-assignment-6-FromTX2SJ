#!/bin/bash
# Eric Schumacker, eds6@rice.edu, SUID S01340401
# Utility to perform benchmarking for asn 3b #9 

buf_range_idx=24

#Configure the kernel per-socket buffer size
sudo sysctl -w net.core.rmem_max=33554432
sudo sysctl -w net.core.rmem_default=33554432

#2thread, pipe
out="2thread-pipe-mem.txt"
for (( i=0; i < buf_range_idx; i++ ))
do
    echo $((2 ** i)) >> $out
    #sudo ./ipc-static -vP mem -i pipe -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l1d -i pipe -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l1i -i pipe -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l2 -i pipe -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P bus -i pipe -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P tlb -i pipe -b $((2 ** i)) 2thread >> $out
done

#2thread, socket
out="2thread-socket-local-mem.txt"
for (( i=0; i < buf_range_idx; i++ ))
do
    echo $((2 ** i)) >> $out
    #sudo ./ipc-static -vP mem -i local -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l1d -i local -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l1i -i local -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l2 -i local -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P bus -i local -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P tlb -i local -b $((2 ** i)) 2thread >> $out
done

#2thread, socket -s
out="2thread-socket-local-tcp-mem.txt"
for (( i=0; i < buf_range_idx; i++ ))
do
    echo $((2 ** i)) >> $out
    #sudo ./ipc-static -vP mem -i local -b $((2 ** i)) -s 2thread >> $out
    sudo ./ipc-static -P l1d -i tcp -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l1i -i tcp -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P l2 -i tcp -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P bus -i tcp -b $((2 ** i)) 2thread >> $out
    sudo ./ipc-static -P tlb -i tcp -b $((2 ** i)) 2thread >> $out
done

