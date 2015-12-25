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
	ssyvector(int s);
	ssyvector(std::initializer_list<double> lst);
	ssyvector( ssyvector& a);
	~ssyvector();

	//copy assignment seems unnecessary
	ssyvector & operator=( ssyvector& );
	//return the n-th element
	double& operator[](int i) ;
	void print ();
	int get_size();

private :
	double * ptr;
	int sz;
};

}

#endif
