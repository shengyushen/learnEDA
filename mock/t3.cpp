// Forward declaration of isBadVersion API.
#include <stdlib.h>
#include <iostream>
#include <assert.h>
#include <vector>
using namespace std;
class Solution {
public:
Solution(){};
	bool revbool(bool i)  {
		if(i) return false;
		else return true;
	}
	int bulbSwitch(int n) {
		vector<bool> vb(n,false);
		int i=1;
		while(i<=n) {
			int ii=i-1;
			while(ii<n) {
				vb[ii]=revbool(vb[ii]);
				ii=ii+i;
			}
			i++;
		}
		int cnt=0;
		for( vector<bool>::size_type i=0;i!=vb.size();++i) {
			if(vb[i]) cnt++;
			cout<<vb[i]<<endl;
		}
		return cnt;
	}
};

int main(int argc,char ** argv) {
char * pend;
int n=static_cast<int>(strtol(argv[1],&pend,10));
Solution sol;
int res=sol.bulbSwitch(n);
cout<<res<<endl;
//	cout<<n<<endl;
}
