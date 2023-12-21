"""
    remove!([rng::AbstractRNG], q::Int, s::Solution, method::Symbol)

    Returns solution `s` after removing `q` nodes using the given `method`.

Available methods include,
- Random Node Removal    : `:randomnode!`
- Related Node Removal   : `:relatednode!`
- Worst Node Removal     : `:worstnode!`

Optionally specify a random number generator `rng` as the first argument
(defaults to `Random.GLOBAL_RNG`).
"""
remove!(rng::AbstractRNG, q::Int, s::Solution, method::Symbol)::Solution = isdefined(TSP, method) ? getfield(TSP, method)(rng, q, s) : getfield(Main, method)(rng, q, s)
remove!(q::Int, s::Solution, method::Symbol) = remove!(Random.GLOBAL_RNG, q, s, method)



"""
    randomnode!(rng::AbstractRNG, q::Int, s::Solution)

Returns solution `s` after removing `q` nodes randomly.
"""
function randomnode!(rng::AbstractRNG, q::Int, s::Solution)
    # Step 1: Initialize
    N = s.N
    I = eachindex(N)
    W = ones(Int, I)            # W[i]: selection weight of node N[i]
    # Step 2: Randomly select customer nodes to remove until q nodes have been removed
    for _ ∈ 1:q
        i  = sample(rng, I, Weights(W))
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        W[i] = 0
    end
    # Step 3: Return solution
    return s
end



"""
    relatednode!(rng::AbstractRNG, q::Int, s::Solution)

Returns solution `s` after removing `q` nodes most related to a randomly selected pivot node.
"""
function relatednode!(rng::AbstractRNG, q::Int, s::Solution)
    # Step 1: Initialize
    N = s.N
    I = eachindex(N)
    X = fill(-Inf, I)           # X[i]: relatedness of node N[i] with node N[j]
    W = ones(Int, I)            # W[i]: selection weight of node N[i]
    # Step 2: Randomly select a pivot customer node
    j = sample(rng, eachindex(N), Weights(W))
    # Step 3: For each customer node, evaluate relatedness to this pivot customer node
    for i ∈ eachindex(N) X[i] = isone(W[i]) ? relatedness(N[i], N[j], s) : -Inf end
    # Step 4: Remove q most related customer nodes
    for _ ∈ 1:q
        i  = argmax(X)
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        X[i] = -Inf
        W[i] = 0
    end
    # Step 5: Return solution
    return s
end



"""
    worstnode!(rng::AbstractRNG, q::Int, s::Solution)

Returns solution `s` after removing `q` nodes with highest removal cost (savings).
"""
function worstnode!(rng::AbstractRNG, q::Int, s::Solution)
    # Step 1: Initialize
    N = s.N
    I = eachindex(N)
    X = fill(-Inf, I)           # X[i]: removal cost of node N[i]
    # Step 2: Iterate until q nodes have been removed
    for _ ∈ 1:q
        # Step 2.1: For every closed node evaluate removal cost
        z = f(s)
        for (i,nₒ) ∈ pairs(N)
            if isopen(nₒ) continue end
            # Step 2.1.1: Remove closed node nₒ between tail node nₜ and head node nₕ
            nₜ = N[nₒ.t]
            nₕ = N[nₒ.h]
            removenode!(nₒ, nₜ, nₕ, s)
            # Step 2.1.2: Evaluate the removal cost
            z⁻ = f(s) * (1 + rand(rng, Uniform(-0.2, 0.2)))
            X[i] = z - z⁻
            # Step 2.1.3: Re-insert node nₒ between tail node nₜ and head node nₕ
            insertnode!(nₒ, nₜ, nₕ, s)
        end
        # Step 2.2: Remove the node with highest removal cost
        i  = argmax(X)
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        # Step 2.3: Update cost vector
        X[i] = -Inf
    end
    # Step 3: Return solution
    return s
end