#include <iostream>
#include <assert.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
using namespace std;

int constt (int x) {
	return x+1;
}

int main() {
	int num=1000*1000*1000;
	{
	time_t tstart=time(NULL);
	for(int i=0;i<=num;i++) {
		pid_t x = getppid();
	}
	time_t tstart2=time(NULL);
	double difft = difftime(tstart2,tstart);
	cout<<"difftime calling getppid for "<<num<<" times is : "<<difft <<endl;
	}

	{
	time_t tstart=time(NULL);
	for(int i=0;i<=num;i++) {
		int x=constt(i);
	}
	time_t tstart2=time(NULL);
	double difft = difftime(tstart2,tstart);
	cout<<"difftime calling constt for "<<num<<" times is : "<<difft <<endl;
	}
	return 0;
}


