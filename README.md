# Overview

This is a Julia wrapper for John Burharkdt's C code to generate nodes and weights for sparse grid integration. Details of the contents of the code can be found at: 

http://people.sc.fsu.edu/~jburkardt/c_src/sparse_grid_hw/sparse_grid_hw.html

By way of overview the built-in families are identified by a 3-letter key which is also the name of the function that returns members of the family:

* GQU: standard Gauss-Legendre quadrature rules, for the unit interval [0,1],with weight function w(x) = 1.
* KPU: Kronrod-Patterson quadrature rules for the unit interval [0,1], with weight function w(x) = 1.
* GQN: standard Gauss-Hermite quadrature rules, for the infinite interval (-∞,+∞), with weight function w(x) = exp(-x<sup>2</sup>/2)/√2π.
* KPN: Kronrod-Patterson quadrature rules for the infinite interval (-∞,+∞) with weight function w(x) = exp(-x<sup>2</sup>/2)/√2π.

# Compiling C Code

To use the code in Julia compile the C-code to create a dynamic library ready to be called by Julia.  If using the 'sparse_grids_hw_jl.sh' in the /src folder, it creates a dynamic library called 'sparselib.dylib' in a new folder, /lib.  

To enable Julia to find the newly created librar, add the path where the library is stored to Julia's DL_LOAD_PATH. One way to do this is to add the line 
```
        push!(Sys.DL_LOAD_PATH,"[Path to new library's folder]")
```
to ~/.juliarc.jl. 

# Calling in Julia

To output nodes and weights specify which integration rule to use, the number of dimensions, and the level accuracy of the integration rule.  The constructor function is:
```
        sgi = nwspgr( rule, dims, level ) 
```
where rule is one of {"GQU","KPU","GQN","KPN"} and sgi is an instance of

```
type nwspgr
    rule 	:: ASCIIString
    dims 	:: Int64
	level	:: Int64
	nodes	:: Array{Float64,2}
	weights :: Vector{Float64}
end
```

The maximum dimension supported by the code is 25. 

