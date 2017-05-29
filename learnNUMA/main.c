#include <stdio.h>
#include <numa.h>


void main(void) {
	printf("hello world\n");
	int numa_av=numa_available();
	printf("numa_available: %d\n",numa_av);
}
