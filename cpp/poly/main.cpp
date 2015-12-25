#include <iostream>
#include <vector>
#include <list>
#include <assert.h>
using namespace std;

struct ssy{
	int i1;
	double d2;
};

//customized output operator
ostream & operator<<(ostream & os , struct ssy ssy_inst) {
	return os<<"struct ssy "<<ssy_inst.i1<<" "<<ssy_inst.d2<<endl;
}
//of course we can design an input stream to do similar job
// but it is more elegent to do this with a parser 
//istream & operator>>(istream & is, struct ssy & ssy_inst) { }

bool find_ssy(list<ssy> ssyl, int x) {
	for(const auto & s : ssyl) {
		if(s.i1==x) {
			return true;
		}
	}
	return false;
}

int main() {
	//vector of struct ssy
	vector<ssy> ssy_vector;
	int sz=10;
	for(int i=0;i<sz;i++) {
		ssy ssy_inst;
		ssy_inst.i1=i;
		ssy_inst.d2=(double)i;
		ssy_vector.push_back(ssy_inst);
	}
	for(const auto & sv:ssy_vector) {
		cout<<sv<<endl;
	}

	//vector init with std_initializor
	vector<int> iv={1,2,3,4};
	vector<string> sv;//size 0
	vector<string> sv1(10);//size 10
	vector<string> sv2(10,"haha");//size 10 and init "haha" all
	vector<string> sv2_move;
	for(const auto & s : sv2) {
		cout<<s<<endl;
	}
	sv2_move=std::move(sv2);
	cout<<"moving sv2 to sv2_move lead sv2 to be empty"<<endl;
	for(const auto & s : sv2) {
		cout<<s<<endl;
	}
	cout<<"while sv2_move is full"<<endl;
	for(const auto & s : sv2_move) {
		cout<<s<<endl;
	}


	cout<<endl<<endl;
	cout<<"tring list"<<endl;
	list<ssy> ssy_list;

	for(int i=0;i<sz;i++) {
		ssy ssy_inst;
		ssy_inst.i1=i;
		ssy_inst.d2=(double)i;
		ssy_list.push_back(ssy_inst);
	}
	for(const auto & sv:ssy_list) {
		cout<<sv<<endl;
	}

	bool ssy_found = find_ssy(ssy_list,5);
	if(ssy_found) {
		cout<<"ssy_found"<<endl;
	}
	
	return 0;
}


