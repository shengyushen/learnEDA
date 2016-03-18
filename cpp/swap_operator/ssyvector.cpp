#include <iostream>
#include <assert.h>
#include "ssyvector.h"
using namespace std;

namespace Ssyvector {

//initializer with direct assignment for elements
ssyvector::ssyvector(int s): 
	sz{s},
	ptr{new double [s]}
{
	//compile time assertion
	//can only used on const expression
	static_assert(4<=sizeof(int),"int size is too small");
	cout<<"ssyvector constructor with size "<<s<<"\n"<<flush;
}

ssyvector::ssyvector(std::initializer_list<double> lst) :
	sz{(int)(lst.size())},
	ptr{new double[lst.size()]}
{
	//it should be inseresting to find out the copy coming from
	copy(lst.begin(),lst.end(),ptr);
	cout<<"ssyvector constructor with list size "<<(lst.size())<<"\n"<<flush;
}
//actually only ref can be passed here
ssyvector::ssyvector( ssyvector & sv)
{
	cout<<"ssyvector constructor with copy \n"<<flush;
	sz = sv.get_size () ;
	ptr = new double[sv.get_size()] ;
	for(int i=0;i<sz;i++) {
		ptr[i]=sv[i];
	}
}


int ssyvector::get_size ( ) {
	return sz;
}

ssyvector::~ssyvector () {
	delete ptr;
	cout<<"ssyvector deleted with size "<<sz<<"\n"<<flush;
}

ssyvector & ssyvector::operator=( ssyvector& sv) {
	//it seems operator = is not need altogether
	cout<<"ssyvector = is called\n"<<flush;
	sz=sv.get_size();
	double * p =new double[sz];
	for(int i=0;i<sz;i++) {
		p[i]=sv[i];
	}
	delete ptr;
	ptr=p;
	return *this;
}

//return the n-th element
double& ssyvector::operator[](int i) {
	assert (i>=0 && i<sz);
	return ptr[i];
}

void ssyvector::print () {
	for(int i=0;i<sz;i++) {
		cout<<ptr[i]<<" "<<flush;
	}
	cout<<endl<<flush;
}




}
