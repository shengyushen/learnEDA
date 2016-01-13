#include <iostream>
#include <vector>
#include<string>

using namespace std;

struct ISGT {};

template<typename T> 
bool ISGT (const T & a, const T &b) {
	if(b<a) return true;
	else return false;
}

template<typename T>  
T varsum (const T & t1 ) {
	return t1;
}

template<typename T , typename ... ARGS>  
T varsum (const T & t1 , const ARGS & ... rest) {
	return t1+(varsum(rest...));
}

template<typename T,typename ... ARGS> 
class ssyvariant {
	
};

int main()
{
	cout<<"2>1 is "<<ISGT(2,1)<<endl;
	cout<<"abc > cde is "<<ISGT("abc","cde")<<endl;
	cout<<"cde > abc is "<<ISGT("cde","abc")<<endl;

	cout<<"1+2+3 is "<< varsum(1,2,3)<<endl;
	string s1("1");
	string s2("2");
	string s3("3");
	cout<<(s1+s2)<<endl;
	cout<<"\"1\"+\"2\"+\"3\" is "<< varsum<string>(s1,s2,s3)<<endl;
	cout<<"\"1\"+\"2\"+\"3\" is "<< varsum<string>("s1",s2,s3)<<endl;
	return 0;
}


