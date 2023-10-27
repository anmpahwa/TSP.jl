"""
    insert!([rng], s::Solution, method::Symbol)

Return solution inserting open nodes to the solution `s` using the given `method`.

Available methods include,
- Best                      : `:best!`
- Precise Greedy Insertion  : `:precise!`
- Perturb Greedy Insertion  : `:perturb!`
- Regret-two Insertion      : `:regret2!`
- Regret-three Insertion    : `:regret3!`

Optionally specify a random number generator `rng` as the first argument
(defaults to `Random.GLOBAL_RNG`).
"""
insert!(rng::AbstractRNG, s::Solution, method::Symbol)::Solution = getfield(TSP, method)(rng, s)
insert!(s::Solution, method::Symbol) = insert!(Random.GLOBAL_RNG, s, method)

# Best insertion
# Insert randomly selected node at its best position until all open nodes have been added to the solution
function best!(rng::AbstractRNG, s::Solution)
    N = s.N
    d = N[1]
    # Step 1: Initialize
    L = [n for n ∈ N if isopen(n)]
    I = eachindex(L)
    W = ones(Int64, I)          # W[i]: sampling weight for node L[i]
    x = Inf                     # x   : insertion cost at best position
    p = (0, 0)                  # p   : best insertion postion
    # Step 2: Iterate until all open nodes have been inserted into the route
    for _ ∈ I
        # Step 2.1: Select a random open node
        z = f(s)
        i = sample(rng, I, Weights(W))
        nₒ = L[i]
        nₜ = d
        nₕ = N[nₜ.h]
        while true
            # Step 2.1.1: Insert node between tail node nₜ and head node nₕ
            insertnode!(nₒ, nₜ, nₕ, s)
            # Step 2.1.2: Compute the insertion cost
            z⁺ = f(s)
            Δ  = z⁺ - z
            # Step 2.1.3: Revise least insertion cost and the corresponding best insertion position
            if Δ < x x, p = Δ, (nₜ.i, nₕ.i) end
            # Step 2.1.4: Remove node from its position between tail node nₜ and head node nₕ
            removenode!(nₒ, nₜ, nₕ, s)
            if isequal(nₕ, d) break end
            nₜ = nₕ
            nₕ = N[nₜ.h]
        end
        # Step 2.2: Insert the node at its best position
        t  = p[1]
        h  = p[2]
        nₜ = N[t]
        nₕ = N[h]
        insertnode!(nₒ, nₜ, nₕ, s)
        # Step 2.3: Revise vectors appropriately
        W[i] = 0
        x = Inf
        p = (0, 0)
    end
    return s
end

# Greedy insertion
# Iteratively insert nodes with least insertion cost at its best position until all open nodes have been added to the solution
function greedy!(rng::AbstractRNG, s::Solution, mode::Symbol)
    N = s.N
    d = N[1]
    φ = isequal(mode, :ptb)
    # Step 1: Initialize
    L = [n for n ∈ N if isopen(n)]
    I = eachindex(L)
    X = fill(Inf, I)            # X[i]: insertion cost of node L[i] at best position
    P = fill((0, 0), I)         # P[i]: best insertion postion of node L[i]
    # Step 2: Iterate until all open nodes have been inserted into the route
    for _ ∈ I
        # Step 2.1: Iterate through all open nodes
        z = f(s)
        for (i,nₒ) ∈ pairs(L)
            # Step 2.1.1: For open node L[i] compute insertion cost for every possible insertion position
            if isclose(nₒ) continue end
            nₜ = d
            nₕ = N[nₜ.h]
            while true
                # Step 2.1.1.1: Insert node between tail node nₜ and head node nₕ
                insertnode!(nₒ, nₜ, nₕ, s)
                # Step 2.1.1.2: Compute the insertion cost
                z⁺ = f(s) * (1 + φ * rand(rng, Uniform(-0.2, 0.2)))
                Δ  = z⁺ - z
                # Step 2.1.1.3: Revise least insertion cost and the corresponding best insertion position
                if Δ < X[i] X[i], P[i] = Δ, (nₜ.i, nₕ.i) end
                # Step 2.1.1.4: Remove node from its position between tail node nₜ and head node nₕ
                removenode!(nₒ, nₜ, nₕ, s)
                if isequal(nₕ, d) break end
                nₜ = nₕ
                nₕ = N[nₜ.h]
            end
        end
        # Step 2.2: Insert node with least insertion cost at its best position
        i  = argmin(X)
        nₒ = L[i]
        t  = P[i][1]
        h  = P[i][2]
        nₜ = N[t]
        nₕ = N[h]
        insertnode!(nₒ, nₜ, nₕ, s)
        # Step 2.3: Revise vectors appropriately
        X .= Inf
        P .= ((0, 0), )
    end
    return s
end
precise!(rng::AbstractRNG, s::Solution) = greedy!(rng, s, :pcs)
perturb!(rng::AbstractRNG, s::Solution) = greedy!(rng, s, :ptb)

# Regret-k Insertion
# Iteratively add nodes with highest regret cost at its best position until all open nodes have been added to the solution
function regretk!(rng::AbstractRNG, s::Solution, k̅::Int64)
    N = s.N
    d = N[1]
    # Step 1: Initialize
    L = [n for n ∈ N if isopen(n)]
    I = eachindex(L)
    X = fill(Inf, I)            # X[i]  : insertion cost of node L[i] at best position
    P = fill((0, 0), I)         # P[i]  : best insertion postion of node L[i]
    Y = fill(Inf, (k̅,I))        # Y[k,i]: insertion cost of node L[i] at kᵗʰ best position
    R = fill(-Inf, I)           # R[i]  : regret-K cost of node L[i]
    # Step 2: Iterate until all open nodes have been inserted into the route
    for _ ∈ I
        # Step 2.1: Iterate through all open nodes
        z = f(s)
        for (i,nₒ) ∈ pairs(L)
            # Step 2.1.1: For node L[i] compute insertion cost for every possible insertion position
            if isclose(nₒ) continue end
            nₜ = d
            nₕ = N[nₜ.h]
            while true
                # Step 2.1.1.1: Insert node between tail node nₜ and head node nₕ
                insertnode!(nₒ, nₜ, nₕ, s)
                # Step 2.1.1.2: Compute the insertion cost
                z⁺ = f(s)
                Δ  = z⁺ - z
                # Step 2.1.1.3: Revise least insertion cost and the corresponding best insertion position
                if Δ < X[i] X[i], P[i] = Δ, (nₜ.i, nₕ.i) end
                # Step 2.1.1.4: Revise K least insertion costs
                k̲ = 1
                for k ∈ 1:k̅
                    k̲ = k
                    if Δ < Y[k,i] break end
                end
                for k ∈ k̅:-1:k̲ Y[k,i] = isequal(k, k̲) ? Δ : Y[k-1,i]::Float64 end
                # Step 2.1.1.5: Remove node from its position between tail node nₜ and head node nₕ
                removenode!(nₒ, nₜ, nₕ, s)
                if isequal(nₕ, d) break end
                nₜ = nₕ
                nₕ = N[nₜ.h]
            end
            # Step 2.1.2: Compute regret cost for node L[i]
            R[i] = 0.
            for k ∈ 1:k̅ R[i] += Y[k,i] - Y[1,i] end
        end
        # Step 2.2: Insert node with highest regret cost at its best position (break ties by inserting the node with the lowest insertion cost)
        I̲  = findall(isequal.(R, maximum(R)))
        i  = I̲[argmin(X[I̲])]
        nₒ = L[i]
        t  = P[i][1]
        h  = P[i][2]
        nₜ = N[t]
        nₕ = N[h]
        insertnode!(nₒ, nₜ, nₕ, s)
        # Step 2.3: Revise vectors appropriately
        X .= Inf
        P .= ((0, 0), )
        Y[:,:] .= Inf
        R .= -Inf
    end
    # Step 3: Return initial solution
    return s
end
regret2!(rng::AbstractRNG, s::Solution) = regretk!(rng, s, Int64(2))
regret3!(rng::AbstractRNG, s::Solution) = regretk!(rng, s, Int64(3))
