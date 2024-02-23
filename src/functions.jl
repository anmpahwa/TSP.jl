"""
    isequal(n₁::Node, n₂::Node)

Return `true` if node `n₁` equals node `n₂`.
Two nodes are equal if their indices (`i`) match.
"""
Base.isequal(n₁::Node, n₂::Node) = isequal(n₁.i, n₂.i)



"""
    isopen(n::Node)
    
Returns `true` if node `n` is open.
A `Node` is defined open if it is not being serviced.
"""
isopen(n::Node) = iszero(n.t) && iszero(n.h)
"""
    isclose(n::Node)
    
Returns `true` if node `n` is closed.
A `Node` is defined closed if it is being serviced.
"""
isclose(n::Node) = !isopen(n)



"""
    relatedness(n₁::Node, n₂::Node, s::Solution)

Returns a measure of similarity between nodes `n₁` and `n₂` in solution `s`.
"""
relatedness(n₁::Node, n₂::Node, s::Solution) = 1 / (s.A[(n₁.i,n₂.i)].c + 1e-5)



"""
    Solution(N::Vector{Node}, A::Dict{Tuple{Int,Int}, Arc})

Returns `Solution` on graph `G = (N, A)`.
"""
function Solution(N::Vector{Node}, A::Dict{Tuple{Int,Int}, Arc})
    c = 0.
    for n ∈ N
        if isopen(n) continue end
        a  = A[(n.i, n.h)]
        c += a.c
    end
    return Solution(N, A, c)
end



"""
    vectorize(s::Solution)

Returns a list of nodes in the order of visit.
"""
function vectorize(s::Solution)
    N = s.N
    V = Int[]
    if all(isopen, N) return V end
    i  = findfirst(isclose.(N))
    nₒ = N[i]
    nₜ = nₒ
    nₕ = N[nₜ.h]
    push!(V, nₒ.i)
    while true
        push!(V, nₕ.i)
        if isequal(nₕ, nₒ) break end
        nₜ = nₕ
        nₕ = N[nₜ.h]
    end
    return V
end
"""
    hash(s::Solution)

Returns hash on vectorized `Solution`.
"""
Base.hash(s::Solution) = hash(vectorize(s))



"""
    isfeasible(s::Solution)

Returns `true` if all nodes are served on the route.
"""
isfeasible(s::Solution) = all(isclose, s.N)



"""
    f(s::Solution)

Returns objective function value.
"""
f(s::Solution) = s.c