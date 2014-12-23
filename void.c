#include <stdio.h>

int main(void) {
	volatile int answer = 42;
	printf("%d\n", *(answer ? &answer : (void*) 0));
	return 0;
}
