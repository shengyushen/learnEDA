// Forward declaration of isBadVersion API.
#include <stdlib.h>
#include <iostream>
using namespace std;
bool isBadVersion(int version) {
if(version >= 1702766719) return true;
else return false;
}
class Solution {
public:
Solution(){};
int firstBadVersion(int n) {
int i=1;
int j=n;
while(true) {
	cout <<i<<" "<<j<<endl;
if(i==j) return i;
else if(i+1==j) {
if(isBadVersion(i)) return i;
else if(isBadVersion(j)) return j;
else return 0;
}
else {
int k = (i+j)/2;
cout<<k<<endl;
if(isBadVersion(k)) {
j=k;
}
else {
i=k+1;
}
}
}
}};
int main(int argc,char ** argv) {
char * pend;
int n=static_cast<int>(strtol(argv[1],&pend,10));
Solution sol;
int res=sol.firstBadVersion(n);
cout<<res<<endl;
//	cout<<n<<endl;
}
