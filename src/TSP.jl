module TSP

using CSV
using DataFrames
using Distributions
using OffsetArrays
using Plots
using ProgressMeter
using Random
using StatsBase

include("datastructure.jl")
include("functions.jl")
include("initialize.jl")
include("operations.jl")
include("remove.jl")
include("insert.jl")
include("localsearch.jl")
include("parameters.jl")
include("ALNS.jl")
include("visualize.jl")

export  build, initialize, 
        vectorize, f, isfeasible, 
        ALNSparameters, ALNS, 
        visualize, animate, pltcnv
        
end