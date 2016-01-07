#include <iostream>
#include <vector>
#include<string>

using namespace std;

int x2 (  int x )  {
	return x*2;
}

int main() {
	typeof(x2(1)) xx;
	xx=x2(1);
	cout<<xx<<endl;
	return 0;
}


