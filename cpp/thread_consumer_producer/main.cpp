#include <iostream>
#include <thread>
#include <chrono>
#include <mutex>
#include <condition_variable>
#include <string>
#include <assert.h>
using namespace std;

struct {
	mutex m_p2c;
	int shared_i;
	bool have_data;
	bool finished;
} sdf_inst;

void producer (int num) {
	for(int i = 0 ; i < num ; i++ ) {
		unique_lock<mutex> ulck(sdf_inst.m_p2c,defer_lock);
		while(true) {
			ulck.lock();
			if(sdf_inst.have_data==false) break;
			else ulck.unlock();
		}
			//locked section
			sdf_inst.shared_i = i;
			sdf_inst.have_data = true;
			ulck.unlock();
	}
	sdf_inst.finished=true;
}


void consumer () {
	while(sdf_inst.finished==false) {
		unique_lock<mutex> ulck(sdf_inst.m_p2c,defer_lock);
		while(true) {
			ulck.lock();
			if(sdf_inst.have_data==true) break;
			else if(sdf_inst.finished==true) return;
			else ulck.unlock();
		}
			//locked section
			cout<<"shared_i "<<sdf_inst.shared_i<<endl<<flush;
			sdf_inst.have_data=false;
			ulck.unlock();
	}
}

condition_variable haha;

int main() {

	int number=100;
	sdf_inst.finished = false;
	sdf_inst.have_data = false;

	thread prod {producer,100};
	thread cons {consumer};

	prod.join();
	cout<<"prod join"<<endl<<flush;
	cons.join();
	return 0;
}


