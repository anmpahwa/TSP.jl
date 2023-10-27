Base.isequal(p::Node, q::Node) = isequal(p.i, q.i)
isopen(n::Node) = isequal(n.t, n.i) & isequal(n.i, n.h)
isclose(n::Node) = !isopen(n)

"""
    vectorize(s::Solution)

Returns solution as a list of nodes in the order of visit.
"""
function vectorize(s::Solution)
    N = s.N
    d = N[1]
    V = Int64[]
    if isopen(d) return V end
    nₜ = d
    nₕ = N[nₜ.h]
    push!(V, d.i)
    while true
        push!(V, nₕ.i)
        if isequal(nₕ, d) break end
        nₜ = nₕ
        nₕ = N[nₜ.h]
    end
    return V
end
Base.hash(s::Solution) = hash(vectorize(s))

"""
    f(s::Solution)

Returns objective function value (solution cost).
"""
f(s::Solution) = s.c

"""
    isfeasible(s::Solution)

Returns true if node service constraint, node flow constraint, and
sub-tour elimination constraint are not violated.
"""
function isfeasible(s::Solution) 
    N  = s.N
    X  = zeros(Int64, length(N))
    nₒ = N[1]
    while true
        k = nₒ.i
        if isone(X[k]) break end
        X[k] = 1
        nₒ = N[nₒ.h]
    end
    if any(iszero, X) return false end
    return true
end