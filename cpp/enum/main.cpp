#include <iostream>
#include <vector>
#include<string>

using namespace std;

union ssy{
int i;
double d;
};
int main()
{
	ssy ssyinst;
	ssyinst.i=1;
	cout<<ssyinst.i<<endl;
	return 0;
}


