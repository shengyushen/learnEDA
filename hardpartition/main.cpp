#include <stdio.h>
#include <list>
#include <iostream>
#include <map>
#include <assert.h>
using namespace std;


map<int,list<list<int>>> size2partlist;

bool isvalid(int i) {
	if(i % 2) return false;
	else if(i<0) return false;
	else return true;
}

bool exist(int i) {
	if(size2partlist.find(i) == size2partlist.end()) return false;
	else return true;
}

void hardpart(int sz) {
	assert(isvalid(sz));
	if(sz==2 || sz==0) return;
	else if(exist(sz)) {
		return ;
	} else {
		for(int i=2;i<sz;i=i+2) {
			hardpart(sz-i);
		}
		list<list<int>> newill={};
		for(int i=2;i<sz;i=i+2) {
			auto oldill=size2partlist[sz-i];
			for(auto oldil : oldill) {
				auto newil = oldil;
				newil.push_back(i);
				newill.push_back(newil);
			}
		}
		//for the sz to be the list with only one element
		newill.push_back({sz});
		size2partlist[sz]=newill;
	}
}

bool isInvalidPartition(list<int> il) {
	int prevcount=0;
	for(auto i : il) {
		assert((i%2)==0);
		if(i>=4 && (prevcount%4)!=0) return true; //from 4x+2 crossing 4x+4
		prevcount=prevcount+i;
	}
	return false;
}

int main(int argc,char**argv) {
	size2partlist={ {0,{}} ,  {2,{{2}} } };
	hardpart(32);

	for(const auto pair : size2partlist) {
		cout<<"FOR "<<pair.first <<endl; 
		for(auto il : pair.second) {
			for(auto i : il) {cout <<i<<" ";}
			if(isInvalidPartition(il)) {cout << " deleted ";}
			cout<<endl;
		}
	}
//	list<int> il;
//	il.push_front(1);
//	il.push_front(2);
//	il.push_back(3);
//	for(int x : il) 
//		cout << x << endl ;
}
