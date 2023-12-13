"""
    build(instance::String; dir=joinpath(dirname(@__DIR__), "instances"))
    
Returns a tuple of nodes and arcs for the `instance`. 

Note, `dir` locates the the folder containing instance files as sub-folders.

    <dir>
    |-<instance>
        |-nodes.csv
        |-arcs.csv
"""
function build(instance::String; dir=joinpath(dirname(@__DIR__), "instances"))
    # Nodes
    df = DataFrame(CSV.File(joinpath(dir, "$instance/nodes.csv")))
    k  = nrow(df)
    K  = 1:k
    N  = Vector{Node}(undef, k)
    for k ∈ K N[k] = Node(df[k,1], df[k,2], df[k,3]) end
    # Arcs
    df = DataFrame(CSV.File(joinpath(dir, "$instance/arcs.csv"), header=false))
    A  = Dict{Tuple{Int,Int},Arc}()
    for i ∈ K for j ∈ K A[(i,j)] = Arc(i, j, df[i,j]) end end
    G  = (N, A)
    return G
end



"""
    savings(instance::String; dir=joinpath(dirname(@__DIR__), "instances"))

Returns initial `Solution` created by merging routes that render the most 
savings until no merger can render further savings. 

Note, `dir` locates the the folder containing instance files as sub-folders.

    <dir>
    |-<instance>
        |-nodes.csv
        |-arcs.csv
"""
function savings(instance::String; dir=joinpath(dirname(@__DIR__), "instances"))
    # Step 1: Initialize
    G = build(instance; dir=dir)
    s = Solution(G...)
    N = s.N
    d = N[1]
    # Step 2: Initialize solution with routes to every node from the depot node (first node)
    k = length(N)
    K = eachindex(N)
    D = [deepcopy(d) for _ ∈ K]
    for k ∈ reverse(K) insertnode!(N[k], D[k], D[k], s) end
    # Step 3: Merge routes iteratively until single route traversing all nodes remains
    X = fill(-Inf, (K,K))       # X[i,j]: Savings from merging route with tail node N[i] into route with tail node N[j]
    ϕ = ones(Int, K)            # ϕ[k]  : binary weight for route k
    for _ ∈ 3:k
        # Step 3.1: Iterate through every route-pair combination
        z = f(s)
        for i ∈ 2:k
            n₁ = N[i]
            d₁ = D[i]
            if !isequal(n₁.h, d₁.i) continue end
            for j ∈ 2:k
                # Step 3.1.1: Merge routes with tail node N[i] into route with tail node N[j]
                n₂ = N[j]
                d₂ = D[j]
                if isequal(n₁, n₂) continue end
                if !isequal(n₂.h, d₂.i) continue end
                if iszero(ϕ[i]) & iszero(ϕ[j]) continue end
                nₕ = d₂
                nₒ = n₁
                nₜ = isone(nₒ.t) ? d₁ : N[nₒ.t]
                while true
                    removenode!(nₒ, nₜ, d₁, s)
                    insertnode!(nₒ, n₂, nₕ, s)
                    if isequal(nₜ, d₁) break end
                    nₕ = nₒ
                    nₒ = nₜ
                    nₜ = isone(nₒ.t) ? d₁ : N[nₒ.t]
                end
                # Step 3.1.2: Compute savings from merging route with tail node N[i] into route with tail node N[j]
                z⁻ = f(s)
                Δ  = z - z⁻
                X[i,j] = Δ
                # Step 3.1.3: Unmerge routes with tail node N[i] into route with tail node N[j]
                nₜ = d₁
                nₒ = N[n₂.h]
                nₕ = isone(nₒ.h) ? d₂ : N[nₒ.h]
                while true
                    removenode!(nₒ, n₂, nₕ, s)
                    insertnode!(nₒ, nₜ, d₁, s)
                    if isequal(nₕ, d₂) break end
                    nₜ = nₒ
                    nₒ = nₕ
                    nₕ = isone(nₒ.h) ? d₂ : N[nₒ.h]
                end
            end
        end
        # Step 3.2: Merge routes that render highest savings
        i,j = Tuple(argmax(X))
        n₁ = N[i]
        d₁ = D[i]
        n₂ = N[j]
        d₂ = D[j]
        nₕ = d₂
        nₒ = n₁
        nₜ = isone(nₒ.t) ? d₁ : N[nₒ.t]
        while true
            removenode!(nₒ, nₜ, d₁, s)
            insertnode!(nₒ, n₂, nₕ, s)
            if isequal(nₜ, d₁) break end
            nₕ = nₒ
            nₒ = nₜ
            nₜ = isone(nₒ.t) ? d₁ : N[nₒ.t]
        end
        D[i] = D[j]
        # Step 3.3: Revise savings and selection vectors appropriately
        X[i, :] .= -Inf
        X[:, i] .= -Inf
        X[j, :] .= -Inf
        X[:, j] .= -Inf
        ϕ .= isequal.(K, i)
    end
    for n ∈ N d.t = isequal(n.h, d.i) ? n.i : d.t end
    for n ∈ N d.h = isequal(n.t, d.i) ? n.i : d.h end
    # Step 4: Return initial solution
    return s
end



"""
    initialize(instance::String; dir=joinpath(dirname(@__DIR__), "instances"))

Returns initial LRP `Solution` developed using Clark and Wright Savings Algorithm 
for the `instance`. 

Note, `dir` locates the the folder containing instance files as sub-folders.
    
    <dir>
    |-<instance>
        |-nodes.csv
        |-arcs.csv
"""
initialize(instance::String; dir=joinpath(dirname(@__DIR__), "instances")) = savings(instance; dir=dir)