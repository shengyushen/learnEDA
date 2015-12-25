#ifndef DEF_SSYVECTOR
#define DEF_SSYVECTOR
#include <string>
//I can even have my own namespace
//in both .h and .cpp
using namespace std;
namespace Ssyvector {


class ssyvector {
public :
	//initializer with direct assignment for elements
	ssyvector(size_t s);
	ssyvector( const ssyvector& a);
	//move constructor
	ssyvector(ssyvector&& a);
	~ssyvector();

	//copy assignment
	ssyvector & operator=( const ssyvector& );
	//move assignment
	ssyvector & operator=( ssyvector&& );
	//return the n-th element
	// const function : notice this const confirm that get_size does not modify its input
	double& operator[](size_t i) const;
	void print ();
	size_t get_size() const;
	double * get_ptr() {return ptr;};
	void * clear() {ptr=nullptr;sz=0;};

private :
	double * ptr;
	size_t sz;
};

}

#endif
