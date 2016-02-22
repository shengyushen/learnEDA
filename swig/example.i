%module example

%{
#define SWIG_FILE_WITH_INIT
extern double ssyd;
extern int fact(int i) ;
%}

extern double ssyd;

extern int fact(int i) ;
