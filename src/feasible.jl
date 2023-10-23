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