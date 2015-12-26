#include <iostream>
#include <thread>
#include <chrono>
#include <string>
#include <mutex>
#include <assert.h>
using namespace std;

// thread only accept value or const ref to avoid data race
// in addition, if you always prefer ti pass ref, 
// then you need std::ref to wrap it in a copyable wrapper
//but that may still violate the data race issue
// I have shown in below three cases
void fref  (  string &  str) { cout << str<<endl; }
void fval  (  string    str) { cout << str<<endl; }

struct F {
	string str;
	F(const string & st) :str{st} {}
	void operator()() {
		cout << str <<endl;
	}
};

int  i;
mutex x1,x2;

void f (char c) {
	for(int i = 0 ; i <= 100000 ; i++ ) {
		// defer_lock means not locking
		//while without it means locking
		//unique_lock means automatically release after out of scope
		unique_lock<mutex> lck1 ( x1 ,defer_lock ); 
		unique_lock<mutex> lck2 ( x2 ,defer_lock );
		//take all lock at the same time
		lock(lck1,lck2);
		cout<<c;
	}
}


int main() {
	string fstr="ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
	string Fstr= "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";

	thread t1 {fref, std::ref(fstr)};
	thread t2 {fval, fstr};
	thread t3 {F{Fstr}};

	thread t4 {f,'a'};
	thread t5 {f,'b'};
	
	t1.join();
	t2.join();
	t3.join();
	t4.join();
	t5.join();

	cout<<endl<<endl;
	auto time0 = chrono::high_resolution_clock::now();
	this_thread::sleep_for(chrono::milliseconds{20});
	auto time1 = chrono::high_resolution_clock::now();
	cout << chrono::duration_cast<chrono::nanoseconds>(time1-time0).count()<< "nanoseconds pass\n";
	return 0;
}


