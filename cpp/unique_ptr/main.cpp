#include <iostream>
#include <vector>
#include<string>
#include<memory>

using namespace std;

unique_ptr<int> gen1 () {
	unique_ptr<int> p1(new int(1));
	return p1;
}
int main() {
	auto x=gen1();
	cout<<*x<<endl;

	return 0;
}


