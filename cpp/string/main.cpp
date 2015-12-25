#include <iostream>
#include <string>
#include <assert.h>
using namespace std;

int main() {
	string name = "shengyu shen";
	cout<<name<<endl;

	string sub = name.substr(2,3);
	cout<<sub<<endl;

	string add=sub+name;
	cout<<add<<endl;

	string replace = name.replace(0,1,"01");
	cout<<replace<<endl;

	replace[0]='O';
	cout<<replace<<endl;


	return 0;
}


