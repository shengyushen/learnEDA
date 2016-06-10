#include <iostream>
#include <errno.h> /* Declares errno and defines error constants */
#include <sys/types.h> /* Type definitions used by many programs */
#include <string.h> /* Commonly used string-handling functions */
#include <unistd.h> /* Prototypes for many system calls */

using namespace std;

int main() {
	auto fn = "non_exist";
	auto fd = fopen(fn,"r");
	if(fd == NULL) {
		perror("perror : ");
		auto errstr = strerror(errno);
		cout<<"strerror : " << errstr <<endl;
	}
	return 0;
}


