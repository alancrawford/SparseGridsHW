# Example taken from www.sparse-grids.de =#

using SparseGridsHW, DataFrames

# Function to Integrate over D-dimensions
function g(x)
	prod( exp(-0.5*((x-µ)/σ).^2)/(√(2π)*σ), 1)
end

# Setup Parameters
D = 10
maxk = 5
µ = 0
σ = 2
rule = "KPU"

# Preallocate
SGerror = zeros(Float64,maxk-1)
Simerror = copy(SGerror)
numnodes = zeros(Int64,maxk-1)
SGtime = copy(SGerror)
Simtime = copy(SGerror)

# True value of Integration
trueval = (.5*erf( 1/(σ*√2) )).^D

for k=2:maxk
	# Call Nodes for Sparse Grid Integration
    nw = nwspgr(rule,D,k)
    # Approximate Integral with accuracy level k (exact up 2k-1 polynomial functions)
    tic(); SGappr = g(nw.nodes)*nw.weights; SGtime[k-1] = toq()
    # Calculate % Appx. Error using SG
    SGerror[k-1] = norm(SGappr - trueval,2)/trueval
    
    # MC Appx using same number of nodes as SG
    numnodes[k-1] = length(nw.weights)
    nodedraws = zeros(1000)
    tic()
    for r=1:1000
        nodedraws[r] = mean(g(rand(D,numnodes[k-1])))
    end
    Simtime[k-1] = toq()
    # Calc % MC appx error
    Simerror[k-1] = norm(mean(nodedraws)-trueval,2)/trueval
end

# Print Output
RowNames = ["k = $i" for i in 2:maxk]
ColNames = ["Num. Nodes", "SG Error (%)" ,"SG time (secs)", "MC Error (%)", "MC time (secs)"]
Output = [numnodes SGerror SGtime Simerror Simtime]
println("*******************************")
println("Dimensions = $D, µ = $µ, σ = $σ")
println("*******************************")
CoefTable(Output,ColNames,RowNames)