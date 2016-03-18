#include <iostream>
#include <vector>

using namespace std;
class IntVector {
	std::vector<int> v;
public:
	IntVector& operator=(IntVector a) {
		IntVector x;
		//x.v=a.v;
		return x;
	};
	void swap(IntVector& other) {
		cout<<"member swap"<<endl;
		v.swap(other.v);
	}
};
void swap(IntVector& v1, IntVector& v2) {
	cout<<"standalonr swap --> member swap"<<endl;
	v1.swap(v2);
}

int main()
{
	IntVector v1, v2;
	std::swap(v1, v2); // compiler error! std::swap requires MoveAssignable
	//    std::iter_swap(&v1, &v2); // OK: library calls unqualified swap()
}
