#include <iostream>
#include <thread>
#include <chrono>
#include <mutex>
#include <condition_variable>
#include <queue>
#include <string>
#include <assert.h>
using namespace std;

using Task_type = void(void);
struct {
	packaged_task<Task_type> pt{producer}
	bool finished;
} sdf_inst;

void print_all () {
	while(sdf_inst.qi.empty()==false) {
		int i = sdf_inst.qi.front();
		sdf_inst.qi.pop();
		cout<<"shared_i "<< i <<endl<<flush;
	}
	return;
}

void producer () {
	for(int i = 0 ; i < 100 ; i++ ) {
		{
			unique_lock<mutex> ulck(sdf_inst.m);//LOCK
				sdf_inst.qi.push(i);
				//cout<<"adding "<<i<<endl<<flush;
		}
		sdf_inst.cv_p2c.notify_one();
	}
	unique_lock<mutex> ulck(sdf_inst.m);//LOCK
	sdf_inst.finished=true;
	sdf_inst.cv_p2c.notify_one();
	return;
}

void consumer () {
	while(true) {
		unique_lock<mutex> ulck(sdf_inst.m);//LOCK
		sdf_inst.cv_p2c.wait(ulck,[]{return sdf_inst.qi.empty()==false || sdf_inst.finished==true ; });
		//wait do three things
		// 1 release the lock
		// 2 wait for condition
		// 3 relock
		print_all();
		if(sdf_inst.finished==true) return;
	}
}

int main() {
	int number=100;
	sdf_inst.finished = false;

	thread prod {producer};
	thread cons {consumer};

	prod.join();
	cons.join();
	return 0;
}


