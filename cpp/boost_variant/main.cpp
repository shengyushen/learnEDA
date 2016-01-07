#include <iostream>
#include <vector>
#include <string>
#include <boost/variant.hpp>

using namespace std;

boost::variant<int, string> sdf;
int main() {
	sdf sdf1(1);
	
	cout<<sdf<<endl;

	return 0;
}


