int main(void) {
	int b[2][2];

//always error
//	b[0][-1]=1;
//may be correct with -unsafe-arrays 
	b[1][-1]=1;
}
