#!/bin/bash -v
swig -python -c++ -o $1_wrap.cpp $1.i 
g++ -c -fpic $1.cpp $1_wrap.cpp -I/usr/include/python2.7
g++ -shared $1.o $1_wrap.o -o _$1.so

