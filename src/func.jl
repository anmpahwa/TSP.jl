Base.isequal(p::Node, q::Node) = isequal(p.i, q.i)
isopen(n::Node) = isequal(n.t, n.i) & isequal(n.i, n.h)
isclose(n::Node) = !isopen(n)

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