#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

/*
sudo hugeadm --pool-pages-min 2M:12M
sudo hugeadm --create-user-mounts=grimy
grep Huge /proc/meminfo
*/

double thrash[1024][512] = {{0}};

int main(void) {
	printf("%ld\n", sizeof(thrash));

	for (int i = 0; i < 1024; ++i)
		if ((thrash[i][0] += 42) != 42)
			printf("BAD %f\n", thrash[i][0]);
	double *p = (double*) mmap(thrash, sizeof(thrash), PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB, -1, 0);
	if (p == MAP_FAILED) {
		perror("mmap failed");
		exit(1);
	}
	printf("%p != %p\n", thrash, p);
	for (int i = 0; i < 1024; ++i)
		if ((p[512 * i] += 42) != 42)
			printf("BAD2 %f\n", p[512 * i]);
	return 0;
}
