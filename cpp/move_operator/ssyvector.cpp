#include <iostream>
#include <assert.h>
#include "ssyvector.h"
using namespace std;

namespace Ssyvector {

//initializer with direct assignment for elements
ssyvector::ssyvector(size_t s): 
	sz{s},
	ptr{new double [s]}
{
	//compile time assertion
	//can only used on const expression
	static_assert(4<=sizeof(int),"int size is too small");
	cout<<"ssyvector alloced with size "<<s<<"\n"<<flush;
}

//actually only ref can be passed here
ssyvector::ssyvector( const ssyvector & sv)
{
	cout<<"copy constructor\n"<<flush;
	sz = sv.get_size () ;
	ptr = new double[sv.get_size()] ;
	for(size_t i=0;i<sz;i++) {
		ptr[i]=sv[i];
	}
}

ssyvector::ssyvector(ssyvector && sv) {
	cout<<"move constructor\n"<<flush;
	ptr=sv.get_ptr();
	sz=get_size();
	sv.clear();
}

size_t ssyvector::get_size ( ) const {
	return sz;
}

ssyvector::~ssyvector () {
	delete ptr;
	cout<<"ssyvector deleted with size "<<sz<<"\n"<<flush;
}

ssyvector & ssyvector::operator=( const ssyvector& sv) {
	//it seems operator = is not need altogether
	cout<<"copy =\n"<<flush;
	sz=sv.get_size();
	double * p =new double[sz];
	for(size_t i=0;i<sz;i++) {
		p[i]=sv[i];
	}
	delete ptr;
	ptr=p;
	return *this;
}

ssyvector & ssyvector::operator=(ssyvector&& sv) {
	cout<<"moving =\n"<<flush;
	delete ptr;
	ptr = sv.get_ptr();
	sz=sv.get_size();
	sv.clear();
	return *this;
}

//return the n-th element
double& ssyvector::operator[](size_t i) const {
	assert (i>=0 && i<sz);
	return ptr[i];
}

void ssyvector::print () {
	for(size_t i=0;i<sz;i++) {
		cout<<ptr[i]<<"\n"<<flush;
	}
}

}
