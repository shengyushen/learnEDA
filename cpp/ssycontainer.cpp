#include <iostream>
#include <assert.h>
#include <memory>
#include "ssycontainer.h"

using namespace std;
using namespace Ssyvector;

ssyvector_container::ssyvector_container(int s):
	// v is already there, so just set its size
	v(s),
	vp{nullptr},
	vup{nullptr}
{
	//such alloced with new will not be freeed automatically
	//I must free them by my self
	vp= new ssyvector (100);
	vup= (unique_ptr<ssyvector> )new ssyvector (101);
}

ssyvector_container::ssyvector_container(initializer_list<double> lst):
	v(lst),
	vp{nullptr}
{
}

double & ssyvector_container::operator[] (int i) {
	return v[i];
}
	
ssyvector_container::~ssyvector_container  () {
	//it seems the member's destructor will bw
	// called automatically
	cout<<"ssyvector_container destr\n"<<flush;
	//such alloced with new will not be freeed automatically
	//I must free them by my self
	if(vp!=nullptr) {
		delete vp;
	}
}

void ssyvector_container::print() {
	v.print();
}
