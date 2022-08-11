[![Build Status](https://github.com/anmol1104/TSP.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/anmol1104/TSP.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/anmol1104/TSP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/anmol1104/TSP.jl)

# Traveling Salesman Problem (TSP)

Given a graph `G = (N,A)` with set of nodes N and set of arcs `A = {(i,j) ; i,j ∈ N}` 
with arc traversal cost `cᵢⱼ ; (i,j) ∈ A`, the objective is to develop a least cost 
route visiting every node exactly once.

This package uses Adaptive Large Neighborhood Search (ALNS) algorithm to find an 
optimal solution for the Traveling Salesman Problem given ALNS optimization 
parameters,
- k̲   :   ALNS segment size
- k̅   :   ALNS iterations
- k̲ₛ  :   Local Search segment size
- k̅ₛ  :   Local Search iterations 
- Ψᵣ  :   Vector of removal operators
- Ψᵢ  :   Vector of insertion operators
- Ψₛ  :   Vector of local search operators
- σ₁  :   Score for a new best solution
- σ₂  :   Score for a new better solution
- σ₃  :   Score for a new worse but accepted solution
- ω   :   Start tempertature control threshold 
- τ   :   Start tempertature control probability
- 𝜃   :   Cooling rate
- C̲   :   Minimum customer nodes removal
- C̅   :   Maximum customer nodes removal
- μ̲   :   Minimum removal fraction
- μ̅   :   Maximum removal fraction
- ρ   :   reaction factor

and an initial solution developed using one of the following methods,
- Clarke and Wright Savings Algorithm   : `:cw_init`
- Nearest Neighborhood Algorithm        : `:nn_init`
- Random Initialization                 : `:random_init`
- Regret K Insertion                    : `:regret₂init`, `:regret₃init`

The ALNS metaheuristic iteratively removes a set of nodes using,
- Random Removal    : `random_remove!`
- Worst Removal     : `worst_remove!`
- Shaw Removal      : `shaw_remove!`

and consequently inserts removed nodes using,
- Best Insertion    : `best_insert!`
- Greedy Insertion  : `greedy_insert!`
- Regret Insertion  : `regret₂insert!`, `regret₃insert!`

In every few iterations, the ALNS metaheuristic performs local search with,
- Move  : `move!`
- 2-Opt : `opt!`
- Swap  : `swap!`

See example.jl for usage