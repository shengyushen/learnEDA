#include <iostream>
#include <vector>
#include<string>

using namespace std;

#define ssyassert(exp) \
	if((exp)==0)         \
		{                  \
			cerr<<"FATAL : "<<endl; \
			exit(1);         \
		}                  
//c++ dont allow the poly one macro
/*#define ssyassert(exp1,exp2) \
	if((exp1)!=(exp2))  { \
		cerr<<"FATAL : "<<endl; \
		exit(1);         \
	}*/
int main()
{
	int ssy=1;
	ssyassert (ssy);
	int ssy1=0;
	ssyassert (ssy1);

//	ssyassert (ssy,ssy1);
	return 0;
}


