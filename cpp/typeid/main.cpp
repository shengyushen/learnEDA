#include <iostream>
#include <vector>
#include<string>
#include<typeinfo>

using namespace std;

int x2 (  int x )  {
	return x*2;
}

class ssy {
	int ssy;
};

int main() {
	ssy ssy1;
	cout<<(typeid(ssy1).name())<<endl;
	return 0;
}


