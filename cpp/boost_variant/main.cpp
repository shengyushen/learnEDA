#include <iostream>
#include <vector>
#include <string>
#include <tuple>
#include <boost/variant.hpp>
using namespace std;
// 1. simple variant
typedef boost::variant<int, string> sdf;

// 2. showing hoe to visit different type
typedef tuple<int> T_exp_number;
typedef tuple<int, int> T_exp_add;
typedef boost::variant< T_exp_number , T_exp_add > vartype;
class vartype_visitor : public boost::static_visitor<void> {
public :
	void operator()(T_exp_number t1) const { cout<<"T_exp_number "<< get<0>(t1) <<endl; }
	void operator()(T_exp_add    t1) const { cout<<"T_exp_add    "<< get<0>(t1) << " " << get<1>(t1) <<endl; }
};


// 3. this example shows that the T_xxx can not be distinguished from T_exp_number
typedef tuple<int> T_xxx;

// 4. we will use an diffrent head type in each tuple to distinguished the current type
// I also show how to use recursive_wrapper without forward declaration
struct recursiveOp_st;
typedef struct recursiveOp_st recursiveOp;
typedef struct {} T_exp_number_ht1;
typedef tuple<T_exp_number_ht1 ,  boost::recursive_wrapper<recursiveOp > > T_exp_number1;

typedef struct {} T_exp_number_ht2;
typedef tuple<T_exp_number_ht2 , int> T_exp_number2;

typedef boost::variant< T_exp_number1 , T_exp_number2 > vartype1;
struct recursiveOp_st {int sdf;} ;


class vartype_visitor1 : public boost::static_visitor<void> {
public :
	void operator()(T_exp_number1 t1) const { cout<<"T_exp_number1 "<< get<1>(t1).sdf <<endl; }
	void operator()(T_exp_number2 t1) const { cout<<"T_exp_number2 "<< get<1>(t1) <<endl; }
};

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
	T_exp_number_ht1 ht1;
	recursiveOp rc;
	rc.sdf=22;
	T_exp_number1 n1(ht1,rc);
	vartype1 vtn1(n1);
	T_exp_number_ht2 ht2;
	T_exp_number2 n2(ht2,2);
	vartype1 vtn2(n2);
	boost::apply_visitor( vartype_visitor1() , vtn1);
	boost::apply_visitor( vartype_visitor1() , vtn2);

	return 0;
}


