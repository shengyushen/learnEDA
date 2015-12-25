#include <iostream>
#include <vector>
#include <assert.h>
using namespace std;

template <typename T> class ssyvector{
private :
	size_t size;
	T* ptr;
public :
	ssyvector(size_t sz) {
		assert (sz>=0);
		size=sz;
		ptr=new T[sz];
	}

	~ssyvector() {
		size=0;
		delete ptr;
	}

	T& operator[](size_t i) {
		return ptr[i];
	}

	void print() {
		for(size_t i =0;i<size;i++) {
			cout << ptr[i]<<" ";
		}
		cout<<"\n"<<flush;
	}

	size_t get_size() {
		return size;
	}
//these two types of operator for begin and end are all OK
	T* begin() {
		return &(ptr[0]);
	}
	
	T* end() {
		return begin()+get_size();
	}
};
/*
template<typename T>
T* begin(ssyvector<T>&x) {
	return &(x[0]);
}

template<typename T>
T* end(ssyvector<T>&x) {
	return begin(x)+x.get_size();
}
*/
int main() {
	ssyvector<double> sv(3);
	sv[0]=2;
	sv[1]=1;
	sv[2]=0;
	cout<<"output with print\n"<<flush;
	sv.print();

	cout<<"output with for-range\n"<<flush;
	for(auto& t:sv) {
		cout<<t<<" "<<flush;
	}
	return 0;
}


