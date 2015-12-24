#ifndef DEF_SSYCONTAINER
#define DEF_SSYCONTAINER

#include <memory>
#include "ssyvector.h"
using namespace std;
using namespace Ssyvector;

class ssycontainer {
public :
	//pure virtual that must be defined
	virtual double& operator[](int s)=0;
	//it have an implementation of destructor?
	//or else the sub class will not find a destructor
	virtual ~ssycontainer() {cout<<"ssycontainer destr\n";} 
	virtual void print()=0;
};


class ssyvector_container : public ssycontainer {
public :
	ssyvector_container(int s);
	ssyvector_container(std::initializer_list<double>);
	~ssyvector_container();
	double & operator[] (int i);
	virtual void print();
private :
	//v is already here, is not a pointer, but an object
	// so I must init it instead of new it
	ssyvector v;
	//using * pointer may lead to forgetting to delete it
	// so a uniqe_ptr shoulb be used
	ssyvector * vp;
	//while a unique_ptr can be used as the owener of an object
	//unique_ptr have no copy constructor, so it can not be copied
	// but only moved, such as return
	//when it is out of scope, then it will destroy its object
	unique_ptr<ssyvector>  vup;
};

#endif

