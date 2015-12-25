#include <iostream>
#include <vector>
#include "ssyvector.h"
#include "ssycontainer.h"

//I can open two namespace at the same time
using namespace std;
using namespace Ssyvector;


constexpr int x2 ( const int x )  {
	return x*2;
}

void print_ssycontainer (ssycontainer & ssyc) {
	ssyc.print();
}

ssyvector & newssyvector (int sz) {
	ssyvector sdf(sz);
	//return only a ref will lead sdf to be freed
	//so we must return a whole sdf
	for(int i=0;i<sz;i++) {
		sdf[i]=i+10000;
	}
	sdf.print();
	return sdf;
}

int main()
{
	//ssyvector
	cout<<"now on ssyvector\n"<<flush;
	ssyvector ssyv(6);
	ssyv[0]=0;
	ssyv[1]=1;
	ssyv[2]=2;
	ssyv[3]=3;
	ssyv[4]=4;
	ssyv[5]=5;


	ssyv.print ();

	ssyvector ssyv1({1.1,2.1,3.1});
	ssyv1.print ();

	//copying a ssyvector
	//actually this is a copy init, not calling copy operator
	ssyvector ssyv_copy=ssyv1;
	cout<<"see after changing ssyv_copy, the old value of ssyv1 is also changed\n"<<flush;
	ssyv_copy[0]=1000;
	ssyv1.print ();
	ssyv_copy.print();

	//calling copy operator
	cout<<"see the copy operator called\n"<<endl;
	ssyvector ssyv_copy2={1.1,2.2,3.3};
	ssyv_copy2=ssyv1;
	cout<<"see the copy operator called finished\n"<<endl;

	//return a ssyvector from a function
	cout<<"see how a ref return from a function\n"<<flush;
	ssyvector sdf_ref = newssyvector (3);
	cout<<flush;
	cout<<"before try assignment\n"<<endl;
	sdf_ref.print();

	//ssyvector_container
	cout<<"now on ssyvector_container\n"<<flush;
	ssyvector_container svc(7);
	svc[0]=0;
	svc[1]=1;
	svc[2]=2;
	svc[3]=3;
	svc[4]=4;
	svc[5]=5;
	svc[6]=6;
	svc.print ();

	cout<<"now on ssyvector_container with list\n"<<flush;
	ssyvector_container svc_list = {1,2,3};
	svc_list.print();

	cout<<"now on using ssyvector_container while only know ssycontainer\n"<<flush;
	print_ssycontainer(svc_list);


	return 0;
}


