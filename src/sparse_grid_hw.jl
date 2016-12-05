#= 

	****************************************************
	Create nodes and weights for Sparse Grid Integration
	****************************************************

Julia code wraps sparse_grids_hw package by John Burkhardt.

Web: http://people.sc.fsu.edu/~jburkardt/c_src/sparse_grid_hw/sparse_grid_hw.html 
 
Created: 21st April 2015

 =#
type nwspgr
	rule 	 :: String
	dims 	 :: Int64
	level	 :: Int64				
	NumNodes :: Int64 				
	nodes	 :: Array{Float64,2}
	weights  :: Vector{Float64}

	# Constructor function 
	function nwspgr(rule::String, dim::Int64, level::Int64 )
		ruledict = Dict("GQU"=>1, "KPU"=>2, "GQN"=>3, "KPN"=>4)
		K = ccall( (:nwspgr_rule_size_wrapper , "sparselib"),
					Int,
					(Int,Int,Int), 
					ruledict[rule] , dim, level);
		x = Array(Float64,dim,K);
		w = Array(Float64,K);
		ccall( (:nwspgr_wrapper, "sparselib"),  
					Void,
					(Int, Int , Int,  Ptr{Cdouble}, Ptr{Cdouble}) ,
					ruledict[rule], dim , level , x, w);
		new(rule, dim, level, K, x, w)
	end
end

function show(io::IO, sgi::nwspgr)
	msg = "\n Nodes and weights for Sparse Grid Integration:\n"
	msg *= "\t - Rule: $(sgi.rule)\n"
	msg *= "\t - Dim: $(sgi.dims)\n"
	msg *= "\t - Accuracy: $(sgi.level)\n"
	print(io, msg) 
end

