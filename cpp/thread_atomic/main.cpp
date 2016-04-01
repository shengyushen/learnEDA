#include <iostream>
#include <thread>
#include <chrono>
#include <string>
#include <mutex>
#include <assert.h>
#include <vector>
#include <atomic>
using namespace std;

class counter {
public :
	std::atomic<int> c;
	//int c;
	counter () :c {0} {};
	void increment () {
		c++;
	}
};

void f(counter &  cnt) {
	for(int i=0;i<100;i++) {
		cnt.increment();
	}
	return;
}

int main() {
	counter cnt;
	cout<<cnt.c<<endl;
	vector<std::thread> threads;
	for(int i=0;i<100;i++) {
		//dont instant the thread and add it to vector like this:
		//thread sdf (f,..)
		//threads.push_back(sdf);
		//this will have copyable problem
		threads.push_back(std::thread{f,std::ref(cnt)});
	}
	for(auto & t : threads) {
		t.join();
	}
	cout<<cnt.c<<endl;
}


