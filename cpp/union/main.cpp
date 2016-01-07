#include <iostream>
#include <vector>
#include<string>

using namespace std;

union cxy {
	int x;
	double y;
};

int main()
{
	cxy u;
	u.x=1;
	cout<<u.y<<endl;
	return 0;
}


