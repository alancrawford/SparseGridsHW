#!/bin/bash
# on macos:
clang -fpic -shared -undefined dynamic_lookup -I. sparse_grid_hw_jl.c -o sparselib.dylib

# On Linux
# gcc -fPIC -shared -I. sparse_grid_hw_jl.c -o sparselib.so

# Move sparselib.dylib to library in the directory
mkdir ../lib
mv sparselib.dylib ../lib

