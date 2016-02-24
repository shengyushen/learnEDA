struct s {
	int a;
	int b[2];
	int c;
};

void main(struct s v) {
//	v.b[-1]=1;
	v.b[2]=4;
}
