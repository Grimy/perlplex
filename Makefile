TLB = -B/usr/share/libhugetlbfs -Wl,--hugetlbfs-align

perf: a.out
	perf stat ./$<

run: a.out
	./$<

a.out: tlb.c Makefile
	gcc -Wall -Wextra -std=gnu99 -O0 -ggdb $(TLB) $<
