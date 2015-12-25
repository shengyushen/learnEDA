#include <iostream>
#include <vector>
#include <assert.h>
#include "ssyvector.h"

//I can open two namespace at the same time
using namespace std;
using namespace Ssyvector;

ssyvector operator+(const ssyvector& a,const ssyvector& b) {
	assert(a.get_size() == b.get_size());
	cout<<"+\n"<<flush;
	size_t sz=a.get_size();

	ssyvector res(sz);
	for(size_t i = 0;i<sz;i++) {
		res[i]=a[i]+b[i];
	}
	return res;
}

ssyvector ret_ssyv() {
	ssyvector sv(21);
		for(size_t i = 0 ; i<21;i++) {
			sv[i]=i;
		}
	return sv;
}

int main()
{
	size_t sz=5;
	ssyvector s10000 (sz);
	for(size_t i=0;i<sz;i++) {
		s10000[i]=(double)i;
	}
	ssyvector a10000{s10000};

	ssyvector c10000 (sz);
	cout<<"begin +\n"<<flush;
	c10000 = s10000+a10000 + s10000;
	c10000.print();

	cout<<"begin even more copy\n"<<flush;
	ssyvector d10000{c10000};
	ssyvector e10000=d10000;

	cout<<"move constructor in std::move and return\n"<<flush;
	//ssyvector f10000= std::move(d10000);
	//I may not see these move or copy constructor called
	//this is due to the common copy elission optimization in
	//most commercial compiler, that remove unnesscery copy or move
	ssyvector sdf(ret_ssyv());
	ssyvector sdf1 =ret_ssyv();
	cout<<"before print\n"<<flush;
	sdf.print();

	return 0;
}


