#include <iostream>
#include "tlpi.h"

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


