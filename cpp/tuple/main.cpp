#include <iostream>
#include <vector>
#include<string>
#include<tuple>

using namespace std;

int main()
{
	tuple<int,char,string> sdf{1,'c',"haha"};
	cout<<get<0>(sdf)<<endl;

	return 0;
}


