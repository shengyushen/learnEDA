#include <iostream>
#include <vector>
#include<string>

using namespace std;

constexpr int x2 ( const int x )  {
	return x*2;
}

int main()
{
	std::cout<<"hello world\n"<<flush;

	int i(10);
	cout<<i<<endl;
	int i11{11};
	cout<<i11<<endl;
	int i12={12};
	cout<<i12<<endl;

	// init with {} is only in C++11
	int i2 {1};
	double d1 {1.7};
	double d2 {1.7};
	vector<double> v {1.1,2.1};

	//auto keyword
	auto b = true;
	auto ch = 'x';
	auto str = "haha\n";
	auto z  {1.5};

	//const
	const auto ic = 1;
	auto inc =1;
	//using constexpr function to define constexpr
	constexpr auto double2_const = x2(ic);
	//using constexpr function to define normal
	auto double2_nonconst = x2(inc);

	//if
	if(b) {
		cout<<"b is true\n"<<flush;
	} else {
		cout<<"b is false\n"<<flush;
	}

	//switch
	switch (b) {
	case true : {
		cout<<"b is true in case\n"<<flush;
		break;
	}
	default : {
		cout<<"b is false in case\n"<<flush;
		break;
	}
	}

	cout<<"finished switch\n"<<flush;

	//while
	int cnt =1 ;
	while(cnt<4) {
		cout<<"cnt is "<<cnt<<"\n"<<flush;
		cnt++;
	}


	char x {'x'};
	char* px = &x;

	//for loop
	int varray[]={1,2,3,4,6,7,8};
	for(auto x :varray) {
		cout<<x<<"\n"<<flush;
	}

	//nullptr is the only null pointer that replace NULL in old C
	char * pc = nullptr;
	if(pc==nullptr) {
		cout<<"pc is nullptr\n"<<flush;
	}


	return 0;
}


