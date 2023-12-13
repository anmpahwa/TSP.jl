# Traveling Salesman Problem (TSP)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/anmol1104/TSP.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/anmol1104/TSP.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/anmol1104/TSP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/anmol1104/TSP.jl)

Given a graph `G = (N,A)` with set of nodes N and set of arcs `A` with arc traversal cost `cᵢⱼ ; (i,j) ∈ A`, the objective of a Traveling Salesman Problem is to develop a least cost route visiting every node exactly once.

This package uses Adaptive Large Neighborhood Search (ALNS) algorithm to find an optimal solution for the Traveling Salesman Problem given an initial solution (here, developed using Clark and Wright savings method) and ALNS optimization parameters,
- `j`     :   Number of segments in the ALNS
- `k`     :   Number of segments to reset ALNS
- `n`     :   Number of iterations in an ALNS segment
- `m`     :   Number of iterations in a local search
- `Ψᵣ`    :   Vector of removal operators
- `Ψᵢ`    :   Vector of insertion operators
- `Ψₗ`    :   Vector of local search operators
- `σ₁`    :   Score for a new best solution
- `σ₂`    :   Score for a new better solution
- `σ₃`    :   Score for a new worse but accepted solution
- `μ̲`     :   Minimum removal fraction
- `c̲`     :   Minimum customer nodes removed
- `μ̅`     :   Maximum removal fraction
- `c̅`     :   Maximum customer nodes removed
- `ω̅`     :   Initial temperature deviation parameter
- `τ̅`     :   Initial temperatureprobability parameter
- `ω̲`     :   Final temperature deviation parameter
- `τ̲`     :   Final temperature probability parameter
- `θ`     :   Cooling rate
- `ρ`     :   Reaction factor

The ALNS metaheuristic iteratively removes a set of nodes using,
- Random Node Removal    : `:randomnode!`
- Related Node Removal   : `:relatednode!`
- Worst Node Removal     : `:worstnode!`

and consequently inserts removed nodes using,
- Best                      : `:best!`
- Precise Greedy Insertion  : `:precise!`
- Perturb Greedy Insertion  : `:perturb!`
- Regret-two Insertion      : `:regret2!`
- Regret-three Insertion    : `:regret3!`

In every few iterations, the ALNS metaheuristic performs local search with,
- Move  : `:move!`
- 2-Opt : `:opt!`
- Swap  : `:swap!`

See bencnhmark.jl for usage

Additional removal, insertion, and local search methods can be defined.