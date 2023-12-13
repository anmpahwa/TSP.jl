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

# -------------------------------------------------- TODO LIST (no particular order) --------------------------------------------------
# TODO: Improve efficiency of move!(rng, k̅, s) with use of relatedness metric to avoid complete enumeration of positions within the route.
# TODO: Improve efficiency of inertion to reduce complete re-evaluation of insertion cost in ever iteration.
# TODO: Calibrate ALNS parameters for improved solution quality as well as run time.