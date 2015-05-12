#= This is a test file for multivariate integration =#

#= MVN integration
	I = ∫g(x,y)dF(x,y)

where
	g(x) = 4 x₁² - 3 x₂³ + x₃⁹ - 2x₄⁴		

	x ~ N(µ,Σ)

Since level of accuracy, k, integrates 2k-1 polynomials we know that k = 5 for exact. 
=#

using SparseGridsHW, DataFrames, Base.show

# Define function g(x)
function g(x)
	return 4x[1].^3 - 3x[2].^2 + x[3].^9 - 2x[4].^4
end

# Setup parameters of MVRN
srand(311)
D = 4
µ = rand(D)
L = tril(rand(D,D))

# For true value use 6 as nests k = 5
nw = nwspgr("KPN",D,6)
tv = 0.
for n in 1:nw.NumNodes
	tv += g(µ .+ L*nw.nodes[:,n])*nw.weights[n]
end


# Set up Integration 
MaxK = 5
NumMCDraws = 1000
SGtime = Float64[]
MCtime = Float64[]
SGerror = Float64[]
MCerror = Float64[]
NN = Float64[]

# Integration
for k = 2:MaxK
	# SG Integration 
	nw = nwspgr("KPN",D,k)
	push!(NN,nw.NumNodes)
	tic()
	I_sg = 0.
	for n in 1:nw.NumNodes
		I_sg += g(µ .+ L*nw.nodes[:,n])*nw.weights[n]
	end
	push!(SGtime,toq())
	push!(SGerror,norm(I_sg-tv,2)/abs(tv))

	# K-node Monte Carlo
	tic()
	I_mc = 0.
	for  i in 1:NumMCDraws, n in 1:nw.NumNodes
		I_mc += g(µ .+ L*randn(D))
	end
	I_mc = I_mc/(nw.NumNodes*NumMCDraws)
	push!(MCtime,toq())
	push!(MCerror,norm(I_mc-tv,2)/abs(tv))
end

RowNames = ["k = $i" for i in 2:MaxK]
ColNames  = ["  Dims  ", "SG Nodes", "SG err (%)" , "MC err (%)", "SG time (secs)", "MC time (secs)" ]
Output = hcat(D*ones(D), NN, SGerror, MCerror, SGtime, MCtime)
show(CoefTable(Output,ColNames,RowNames))
println("\nNote: Number of draws for MC is $NumMCDraws of vectors of length of SG nodes\n")
