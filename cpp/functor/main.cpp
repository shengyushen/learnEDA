#include <iostream>
#include <vector>
#include <algorithm>
#include <assert.h>
using namespace std;
//very inconvenient than ocaml, which directly pass x<val 
template <typename T>
class lessthan{
private :
	const T val;
public :
	lessthan(const T & v):  val{v} { }
	bool operator()(const T & x) const {return x<val;}
};

int main() {
	lessthan<int> lti(2);
	if(lti(1)) {
		cout<<"lti\n"<<flush;
	}

	vector<int> sdf={1,2,3};
	int x = count_if(sdf.begin(),sdf.end(),lti);
	cout<<"number of <2 is "<<x<<endl;

	//[] capture nothing
	//[&] capture all as ref
	//[&x] capture x as ref
	//[=] capture all as copy
	//[=x] capture x as copy
	int y = count_if(sdf.begin(),sdf.end(),[&](int & x){return x<3;});
	cout<<"number of <3 is "<<y<<endl;
	return 0;
}


