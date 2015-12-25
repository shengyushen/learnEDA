#include <iostream>
#include <vector>
#include "ssyvector.h"

//I can open two namespace at the same time
using namespace std;
using namespace Ssyvector;


constexpr int x2 ( const int x )  {
	return x*2;
}

int main()
{
	{
		cout<<"\n"<<flush;
		cout<<"init with size and filling 0-5\n"<<flush;
		ssyvector ssyv(6);
		ssyv[0]=0;
		ssyv[1]=1;
		ssyv[2]=2;
		ssyv[3]=3;
		ssyv[4]=4;
		ssyv[5]=5;
		ssyv.print ();
	}

	{
		cout<<"\n"<<flush;
		cout<<"init initializer_list 1.1 2.1 3.1\n"<<flush;
		ssyvector ssyv1({1.1,2.1,3.1});
		ssyv1.print ();
	}
	
	{
		cout<<"\n"<<flush;
		cout<<"init refenrece\n"<<flush;
		ssyvector ssyv1({1.1,2.1,3.1});
		ssyvector ssyv2(ssyv1);
		ssyv2.print();
	}
		
	{
		cout<<"\n"<<flush;
		cout<<"init with =\n"<<flush;
		ssyvector ssyv1({1.1,2.1,3.1});
		ssyvector ssyv_copy=ssyv1;
		ssyv_copy[0]=1000;
		ssyv1.print ();
		ssyv_copy.print();
	}
	
	{
		cout<<"\n"<<flush;
		cout<<"copy operator called\n"<<endl;
		ssyvector ssyv_copy2={1.1,2.2,3.3};
		ssyvector ssyv1({1.1,2.1,3.1});
		ssyv_copy2=ssyv1;
		ssyv_copy2.print();
		cout<<"copy operator finished\n"<<endl;
	}
	
	return 0;
}


