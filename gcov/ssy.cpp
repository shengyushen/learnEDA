#include <iostream>

using namespace std;
#include "isok.hpp"

int main( int argc,char**argv) {
	if(argc!=2) {
		cerr<<"usage : ./a.out <1|2>"<<endl;
		return 1;
	}

	string s(argv[1]);
	if(isOne(s)) {
		cout<<"1"<<endl;
	} else {
		cout<<"not 1"<<endl;
	}
}
