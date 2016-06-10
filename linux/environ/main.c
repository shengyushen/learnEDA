#include <errno.h> /* Declares errno and defines error constants */
#include <sys/types.h> /* Type definitions used by many programs */
#include <string.h> /* Commonly used string-handling functions */
#include <unistd.h> /* Prototypes for many system calls */
#include <stdio.h>

extern char ** environ ;

int main(int argc , char ** argv) {
//	while(p!=NULL) {
//		printf("%s\n",p);
		puts(*environ);
//		p++;
//	}
	return 0;
}


