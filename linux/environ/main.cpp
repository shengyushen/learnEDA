#include <errno.h> /* Declares errno and defines error constants */
#include <sys/types.h> /* Type definitions used by many programs */
#include <string.h> /* Commonly used string-handling functions */
#include <unistd.h> /* Prototypes for many system calls */
#include <stdio.h>
#include <stdlib.h>

//we can use the extern one or use it as the last argument
/*extern char ** environ ;
int main(int argc , char ** argv) {*/

int main(int argc , char ** argv,char ** environ) {
	char ** p= environ;
	while((*p)!=NULL) {
		printf("%s\n",*p);
		p++;
	}
	
	printf("\n using getenv to get SHELL\n");

	char * sdf=getenv("SHELL");
	printf("%s\n",sdf);

	return 0;
}


