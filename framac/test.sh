#!/bin/bash -v

echo "" > err

#checking array out of bound on simple code
frama-c arrayOutBound.c -val
#checking array out of bound in loop
frama-c arrayLoop.c -val
# with -unsafe-arrays 
frama-c array2DimensionUnsafe.c -val -unsafe-arrays
