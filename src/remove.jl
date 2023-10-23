# NOTE: The first node, assumed to be the depot node, is prohibited from being removed.

"""
    remove!([rng], q::Int64, s::Solution, method::Symbol)

Return solution removing `q` nodes from solution `s` using the given `method`.

Available methods include,
- Random Node Removal    : `:randomnode!`
- Related Node Removal   : `:relatednode!`
- Worst Node Removal     : `:worstnode!`

Optionally specify a random number generator `rng` as the first argument
(defaults to `Random.GLOBAL_RNG`).
"""
remove!(rng::AbstractRNG, q::Int64, s::Solution, method::Symbol)::Solution = getfield(TSP, method)(rng, q, s)
remove!(q::Int64, s::Solution, method::Symbol) = remove!(Random.GLOBAL_RNG, q, s, method)

# Random Node Removal
# Randomly select q nodes to remove
function randomnode!(rng::AbstractRNG, q::Int64, s::Solution)
    N = s.N
    I = eachindex(N)
    W = (!isone).(I)            # W[i]: sampling weight of node N[i]
    # Step 1: Randomly select customer nodes to remove until q nodes have been removed
    for _ ∈ 1:q
        i  = sample(rng, I, Weights(W))
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        W[i] = 0
    end
    # Step 2: Return solution
    return s
end

# Related (Shaw) Node Removal
# For a randomly selected customer node, remove q most related customer nodes
function relatednode!(rng::AbstractRNG, q::Int64, s::Solution)
    N = s.N
    A = s.A
    I = eachindex(N)
    W = (!isone).(I)            # W[i]: sampling weight of node N[i]
    X = fill(-Inf, I)           # X[i]: relatedness of node N[i] with node N[j]
    # Step 1: Randomly select a pivot customer node
    j = sample(rng, I, Weights(W))
    # Step 2: For each customer node, evaluate relatedness to this pivot customer node
    for i ∈ I
        if isone(i) continue end
        a = A[(i,j)]
        X[i] = 1/a.c
    end
    # Step 3: Remove q most related customer nodes
    for _ ∈ 1:q
        i  = argmax(X)
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        X[i] = -Inf
    end
    # Step 4: Return solution
    return s
end

# Worst Node Removal
# Remove q nodes with highest removal cost
function worstnode!(rng::AbstractRNG, q::Int64, s::Solution)
    N = s.N
    I = eachindex(N)
    X = fill(-Inf, I)           # X[i]: removal cost of node N[i]
    # Step 1: Iterate until q nodes have been removed
    for _ ∈ 1:q
        # Step 1.1: For every closed node evaluate removal cost
        z = f(s)
        for (i,nₒ) ∈ pairs(N)
            if isone(i) continue end
            if isopen(nₒ) continue end
            # Step 1.1.1: Remove closed node nₒ between tail node nₜ and head node nₕ
            nₜ = N[nₒ.t]
            nₕ = N[nₒ.h]
            removenode!(nₒ, nₜ, nₕ, s)
            # Step 1.1.2: Evaluate the removal cost
            z⁻ = f(s) * (1 + rand(rng, Uniform(-0.2, 0.2)))
            X[i] = z - z⁻
            # Step 1.1.3: Re-insert node nₒ between tail node nₜ and head node nₕ
            insertnode!(nₒ, nₜ, nₕ, s)
        end
        # Step 1.2: Remove the node with highest removal cost
        i  = argmax(X)
        nₒ = N[i]
        nₜ = N[nₒ.t]
        nₕ = N[nₒ.h]
        removenode!(nₒ, nₜ, nₕ, s)
        # Step 1.3: Update cost vector
        X[i] = -Inf
    end
    # Step 2: Return solution
    return s
end