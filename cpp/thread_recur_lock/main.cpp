#include <iostream>
#include <thread>
#include <chrono>
#include <string>
#include <mutex>
#include <assert.h>
#include <vector>
using namespace std;

class counter {
public :
	int c;
//	mutex mtx;
	recursive_mutex mtx;
	counter () :c {0} {};
	void increment_internal () {
		//acquaire mtx again will cause dead lock
		//lock_guard<mutex> guard(mtx);
		lock_guard<recursive_mutex> guard(mtx);
		c++;
	}
	void increment () {
//		lock_guard<mutex> guard(mtx);
		lock_guard<recursive_mutex> guard(mtx);
		increment_internal();
	}
};

std::once_flag flg;
void f(counter &  cnt) {
	call_once(flg,[](){cout<<"only once"<<endl;});
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


