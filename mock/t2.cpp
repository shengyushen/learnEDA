// Forward declaration of isBadVersion API.
#include <stdlib.h>
#include <iostream>
#include <assert.h>
using namespace std;
class Solution {
public:
Solution(){};
	int getlogpower(int power) {
		assert((power%10)==0 || power==1);
		int tt=power;
		int cnt=0;
		while(tt!=1) {
			cnt++;
			tt=tt/10;
		}
		return cnt;
	}
	int get19cnt(int power) {
		int powerlog=getlogpower(power);
		return power+powerlog*9*power/10;
	}
	int get09cnt(int power) {
		int x=  (getlogpower(power)+1)*power;
		cout<<"get09cnt "<< power<<" is "<<x<<endl;
		return x;
	}
	int getnumberlogpower(int n) {
		int power=0;
		int j=n;
		while(j/10!=0) {
			j=j/10;
			power++;
		}
		return power;
	}
	int getnumberpower(int n) {
		int power=1;
		int j=n;
		while(j/10!=0) {
			j=j/10;
			power=power*10;
		}
		return power;
	}
	int getmulpower(int n) {
		return n/(getnumberpower(n));
	}
	int countDigitOne(int n) {
		//all count
		int cntall=0;
		//left number
		int leftnum=0;
		int left1num=0;
		int j=n;
		int currentpower=getnumberpower(n);
		while(j!=0){
			int m=j/currentpower;
			cout<<endl<<"j "<<j<<endl;
			cout<<"left1num "<<left1num <<endl;
			cout<<"m "<<m<<endl;
			cout<<"cntall "<<cntall<<endl;
			
			if(m==0) {
//				cntall=cntall+left1num;
			} else {
				int rightcnt;
				if(currentpower!=1) {rightcnt=get09cnt(currentpower/10);}
				else rightcnt=0;
				int inc=m*rightcnt;//1 on right hand side
				cout<<"rightpos all "<<m*rightcnt<<endl;
				if(m>1) {
					inc=inc+currentpower;//1 on m position
					cout<<"m pos "<<currentpower<<endl;
				}
				//1 on left handside
				inc=inc+left1num*currentpower*m;
				cout<<"left pos "<<left1num*currentpower*m<<endl;
				cout<<"rightcnt "<< rightcnt<<endl;
				cout<<"currentpower " << currentpower<<endl;
				cout<<"inc "<<inc<<endl;

				cntall=cntall+inc;
			}

			j=j-m*currentpower;
			currentpower=currentpower/10;
			leftnum=leftnum*10+m;
			if(m==1) left1num++;
		}

		return cntall+left1num;
	}
};

int main(int argc,char ** argv) {
char * pend;
int n=static_cast<int>(strtol(argv[1],&pend,10));
Solution sol;
//int res=sol.countDigitOne(n);
//int res=sol.getlogpower(n);
//int res=sol.get19cnt(n);
//int res=sol.get09cnt(n);
int res=sol.countDigitOne(n);
cout<<res<<endl;
//	cout<<n<<endl;
}
