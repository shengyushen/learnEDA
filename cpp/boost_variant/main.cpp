#include <iostream>
#include <vector>
#include <string>
#include <tuple>
#include <memory>
#include <boost/variant.hpp>
using namespace std;
// 1. simple variant
typedef boost::variant<int, string> sdf;

// 2. showing hoe to visit different type
typedef tuple<int> T_exp_number;
typedef tuple<int, int> T_exp_add;
typedef boost::variant< T_exp_number , T_exp_add > vartype;
class vartype_visitor : public boost::static_visitor<void> {
public:
	void operator()(T_exp_number t1) const { cout<<"T_exp_number "<< get<0>(t1) <<endl; }
	void operator()(T_exp_add    t1) const { cout<<"T_exp_add    "<< get<0>(t1) << " " << get<1>(t1) <<endl; }
};


// 3. this example shows that the T_xxx can not be distinguished from T_exp_number
typedef tuple<int> T_xxx;

// 4. we will use an diffrent head type in each tuple to distinguished the current type
// I also show how to use recursive_wrapper without forward declaration

class x1;
class x2;
typedef class x1 x1;
typedef class x2 x2;

typedef boost::variant<shared_ptr<x1> , shared_ptr<x2>> bv;
class x1 {
public:
	int d;
	x1(int i) : d(i) {}
};

class x2 {
public:
	double d;
	x2(double i): d(i) {}
};

class bv_visitor : public boost::static_visitor<void> {
public:
	void operator()(shared_ptr<x1> px1) const { cout<<"px1 "<< px1->d <<endl; }
	void operator()(shared_ptr<x2> px2) const { cout<<"px2 "<< px2->d <<endl; }
};

shared_ptr<x1> px1 () {
	shared_ptr<x1> px1=make_shared<x1>(111111);
	cout<<"px1 use_count "<<(px1.use_count())<<endl;
	return px1;
}

int main() {
// 1. simple variant
	sdf sdf1(1);
	cout<<sdf1<<endl;

// 2. showing hoe to visit different type
	T_exp_number t1(1);
	vartype sdf2(t1);
	boost::apply_visitor( vartype_visitor() , sdf2 );

	T_exp_add t2(1,1);
	vartype sdf3(t2);
	boost::apply_visitor( vartype_visitor() , sdf3 );

// 3. this example shows that the T_xxx can not be distinguished from T_exp_number
	T_xxx t_xxx(1);
	vartype vt_xxx (t_xxx);
	boost::apply_visitor( vartype_visitor() , vt_xxx);

// 4. we will use an diffrent head type in each tuple to distinguished the current type
	auto px=px1();
	shared_ptr<x2> px2=make_shared<x2>(1.11111);
	auto px11=px;
	cout<<"px11 use_count "<<px11.use_count()<<endl;
	bv bv1(px11);
	bv bv2(px2);
	boost::apply_visitor( bv_visitor() , bv1);
	boost::apply_visitor( bv_visitor() , bv2);
	return 0;
}


