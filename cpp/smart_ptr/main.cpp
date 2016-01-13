#include <iostream>
#include <vector>
#include<string>
#include<memory>
#include<list>

using namespace std;


int main()
{
	string s1{"ssy"};
	shared_ptr<string> pstr = std::make_shared<string>(s1);
	cout<<*pstr<<endl;
	
	shared_ptr<std::list<std::string>> p1=make_shared<list<string>>();
	//cout<<str1<<endl;
	p1->push_back(s1);
	for(auto & v : *p1) {
		cout<<v<<endl;
	}

	shared_ptr<std::list<std::string>> p2=p1;

	return 0;
}


