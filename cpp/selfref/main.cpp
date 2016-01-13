#include <iostream>
#include <vector>
#include<string>
#include<memory>

using namespace std;

class base {
	public :
	int i;
	base(int i1) : i{i1} {}
	virtual void prt (void) {
		cout<<"base "<<i<<endl;
	}
};

class sub : public base {
	public :
	sub(int i1) : base{i1} {}
	virtual void prt (void) {
		cout<<"sub"<<i<<"\n";
	}
};

int main()
{
	base b1{1};
	b1.prt();

	sub s1{2};
	s1.prt();

	auto ps1=make_shared<sub>(3);
	ps1->prt();
	
	shared_ptr<sub> pb1=ps1;
	ps1->prt();
	return 0;
}


