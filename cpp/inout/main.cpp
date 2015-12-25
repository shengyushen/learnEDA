#include <iostream>
#include <string>
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

int main() {
	string name = "shengyu shen";
	cout<<name<<endl;

	string sub = name.substr(2,3);
	cout<<sub<<endl;

	string add=sub+name;
	cout<<add<<endl;

	string replace = name.replace(0,1,"01");
	cout<<replace<<endl;

	replace[0]='O';
	cout<<replace<<endl;

	struct ssy ssy_inst ;
	ssy_inst.i1=1;
	ssy_inst.d2=1.1;
	cout<<ssy_inst<<endl;

	cout<<"cin only accept on word"<<endl;
	cin>>name;
	cout<<"only get a word\n"<<name<<endl;

	cout<<"getline get a whole line without endl "<<endl;
	cout<<"also the remaining word from previous input"<<endl;
	getline(cin,name);
	cout<<"a whole line\n"<<name<<endl;
	return 0;
}


