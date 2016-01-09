#include <iostream>
#include <vector>
#include<string>
#include<tuple>

using namespace std;

typedef tuple<int> T_exp_number;
typedef tuple<int, int> T_exp_add;

int main()
{
	tuple<int,char,string> sdf{1,'c',"haha"};
	cout<<get<0>(sdf)<<endl;
	
	T_exp_number t1{1};
	cout<< get<0>(t1) <<endl;

	T_exp_add t2(1,2);
	cout<< get<1>(t2) <<endl;

	return 0;
}


