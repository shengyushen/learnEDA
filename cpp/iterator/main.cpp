#include <iostream>
#include <vector>
#include<string>
#include<list>

using namespace std;


int main()
{
	list<int> haha={1,2,3};
	for(auto &x :haha) {
		cout<<(x)<<endl;
	}
	return 0;
}


