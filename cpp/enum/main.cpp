#include <iostream>
#include <vector>
#include<string>

using namespace std;

union ssy{
int i;
double d;
};

enum sdf {
	T1,
	T2
};

int main()
{
	ssy ssyinst;
	ssyinst.i=1;
	cout<<ssyinst.i<<endl;

	sdf en;
	en=T1;
	return 0;
}


