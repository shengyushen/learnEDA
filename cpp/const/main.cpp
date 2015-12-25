#include <iostream>
#include <vector>
#include <memory>

//I can open two namespace at the same time
using namespace std;

class inner {
public :
	void f() const {cout<<"f const\n"<<flush;}
	void f() {cout<<"f non const\n"<<flush;}
};


class outer {
inner inner_inst;
public :
	void g() const {inner_inst.f();cout<<"g const\n"<<flush;}
	void g() {inner_inst.f();cout<<"g non const\n"<<flush;}
};

class outer_ptr {
public :
inner * inner_inst;
	outer_ptr() {inner_inst = new inner();}
	//this const means this function will not change this
	void g() const {inner_inst->f();cout<<"g const\n"<<flush;}
	void g() {inner_inst->f();cout<<"g non const\n"<<flush;}
};

int main()
{
	cout<<"non const instance both\n"<<flush;
	outer outer_inst;
	outer_inst.g();

	cout<<"\n"<<flush;
	cout<<"const instance both\n"<<flush;
	const outer outer_inst_const;
	outer_inst_const.g();

	cout<<"\n"<<flush;
	cout<<"const outer_ptr * mean const object\n"<<flush;
	//equal to outer_ptr const
	//both means const object
	const outer_ptr  *  outer_ptr_inst = new outer_ptr();
	//below is invalid
	//outer_ptr_inst -> inner_inst = nullptr;
	outer_ptr_inst->g();

	cout<<"\n"<<flush;
	cout<<"outer_ptr * const means const pointer to non-const object\n"<<flush;
	outer_ptr * const outer_ptr_inst_const3 = new outer_ptr();
	outer_ptr_inst_const3->g();
	
	return 0;
}


