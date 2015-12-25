#include <iostream>
#include <vector>
#include "ssyvector.h"
#include "ssycontainer.h"

//I can open two namespace at the same time
using namespace std;
using namespace Ssyvector;


void print_ssycontainer (ssycontainer & ssyc) {
	ssyc.print();
}

int main()
{
	//ssyvector_container
	cout<<"now on ssyvector_container\n"<<flush;
	ssyvector_container svc(2);

	cout<<"now on ssyvector_container with list\n"<<flush;
	ssyvector_container svc_list = {1,2,3};
	svc_list.print();

	cout<<"now on using ssyvector_container while only know ssycontainer\n"<<flush;
	print_ssycontainer(svc_list);


	return 0;
}


