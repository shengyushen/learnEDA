#include <iostream>
#include <vector>
#include<string>

using namespace std;

void prt_sep(string s) {
	cout<<s;
}

void prt_wrap(void p(string s)) {
	p("1");
}

int main()
{
	prt_wrap(prt_sep);
	prt_wrap([](string s){cout<<s; return ;});
	return 0;
}


