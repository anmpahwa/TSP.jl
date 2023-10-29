"""
    insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution)

Returns solution `s` after inserting node `nᵒ` between tail node `nᵗ` 
and head node `nʰ` in solution `s`.
"""
function insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution)
    aₒ = s.A[(nₜ.i, nₕ.i)]
    aₜ = s.A[(nₜ.i, nₒ.i)]
    aₕ = s.A[(nₒ.i, nₕ.i)]
    nₜ.h = nₒ.i
    nₕ.t = nₒ.i
    nₒ.t = nₜ.i
    nₒ.h = nₕ.i
    s.c += aₜ.c + aₕ.c - aₒ.c
    return s
end

"""
    removenode!(nᵒ::Node, nᵗ::Node, nʰ::Node, s::Solution)

Returns solution `s` after removing node `nᵒ` from its position between 
tail node `nᵗ` and head node `nʰ` in solution `s`.
"""
function removenode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution)
    aₒ = s.A[(nₜ.i, nₕ.i)]
    aₜ = s.A[(nₜ.i, nₒ.i)]
    aₕ = s.A[(nₒ.i, nₕ.i)]
    nₜ.h = nₕ.i
    nₕ.t = nₜ.i
    nₒ.t = nₒ.i
    nₒ.h = nₒ.i
    s.c -= aₜ.c + aₕ.c - aₒ.c
    return s
end