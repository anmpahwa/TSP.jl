"""
    insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution; ignore=false)

Insert node `nₒ` between tail node `nₜ` and head node `nₕ` in solution `s`.
Ignores argument errors if ignore is true.
"""
function insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution; ignore=false)
    if !ignore if isclose(nₒ) throw(ArgumentError("Node nₒ (node $(nₒ.i)) is closed")) end end
    A  = s.A 
    aₒ = A[(nₜ.i, nₕ.i)]
    aₜ = A[(nₜ.i, nₒ.i)]
    aₕ = A[(nₒ.i, nₕ.i)]
    nₜ.h = nₒ.i
    nₕ.t = nₒ.i
    nₒ.t = nₜ.i
    nₒ.h = nₕ.i
    s.c += aₜ.c + aₕ.c - aₒ.c
    return
end

"""
    removenode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution; ignore=false)

Remove node `nₒ` from its position between tail node `nₜ` and head node `nₕ` in solution `s`.
Ignores argument errors if ignore is true.
"""
function removenode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution; ignore=false)
    if !ignore
        if !isequal(nₒ.t, nₜ.i) throw(ArgumentError("Tail index of node nₒ (node $(nₒ.i)) != Index of tail node nₜ (node $(nₜ.i))")) end
        if !isequal(nₜ.h, nₒ.i) throw(ArgumentError("Head index of tail node nₜ (node $(nₜ.i)) != Index of node nₒ (node $(nₒ.i))")) end
        if !isequal(nₒ.h, nₕ.i) throw(ArgumentError("Head index of node nₒ (node $(nₒ.i)) != Index of head node nₕ (node $(nₕ.i))")) end
        if !isequal(nₕ.t, nₒ.i) throw(ArgumentError("Tail index of head node nₕ (node $(nₕ.i)) != Index of node nₒ (node $(nₒ.i))")) end
    end
    A  = s.A 
    aₒ = A[(nₜ.i, nₕ.i)]
    aₜ = A[(nₜ.i, nₒ.i)]
    aₕ = A[(nₒ.i, nₕ.i)]
    nₜ.h = nₒ.h
    nₕ.t = nₒ.t
    nₒ.t = nₒ.i
    nₒ.h = nₒ.i
    s.c -= aₜ.c + aₕ.c - aₒ.c
    return
end