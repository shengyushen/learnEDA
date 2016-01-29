#include <iostream>
#include <vector>
#include<string>

using namespace std;

void x2 ( void(*f)(void) )  {
	f();
}

void prt() {
	cout<<"1"<<endl;
}

int main()
{
	x2(prt);


	return 0;
}


