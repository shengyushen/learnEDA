#ifndef DEF_SSYCONTAINER
#define DEF_SSYCONTAINER

#include <memory>
#include "ssyvector.h"
using namespace std;
using namespace Ssyvector;

class ssycontainer {
public :
	//it have an implementation of destructor?
	//or else the sub class will not find a destructor
	virtual ~ssycontainer() {cout<<"ssycontainer destr\n";} 
	//pure virtual that must be defined
	virtual void print()=0;
};


class ssyvector_container : public ssycontainer {
public :
	ssyvector_container(int s);
	ssyvector_container(std::initializer_list<double>);
	~ssyvector_container();
	virtual void print();
private :
	//v is already here, is not a pointer, but an object
	// so I must init it instead of new it
	ssyvector v;
	//using * pointer may lead to forgetting to delete it
	// so a uniqe_ptr or an member object shoulb be used
	ssyvector * vp;
};

#endif

