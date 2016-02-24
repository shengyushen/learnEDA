
int tab[10]=1;

int x ;

int *p = &x;

//@ requires p == &x;

int main(void){
//@ assert tab[0]==1 && *p == x;
//@ assert *tab == 1;

int *q = &tab[3];

//@ assert q+1 == tab+4;


}
