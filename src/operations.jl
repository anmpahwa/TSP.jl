"""
    insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution; ignore=false)

Insert node `nₒ` between tail node `nₜ` and head node `nₕ` in solution `s`.
"""
function insertnode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution)
    if isclose(nₒ) throw(ArgumentError("Node nₒ ($(nₒ.i)) is closed")) end
    if !isequal(nₜ.h, nₕ.i) throw(ArgumentError("Head index of tail node nₜ ($(nₜ.i)) does not match the index of head node nₕ ($(nₕ.i)) ")) end            
    if !isequal(nₕ.t, nₜ.i) throw(ArgumentError("Tail index of head node nₕ ($(nₕ.i)) does not match the index of tail node nₜ ($(nₜ.i)) ")) end
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
"""
function removenode!(nₒ::Node, nₜ::Node, nₕ::Node, s::Solution)
    if !isequal(nₒ.t, nₜ.i) throw(ArgumentError("Tail index of node nₒ ($(nₒ.i)) does not match the index of tail node nₜ ($(nₜ.i))")) end
    if !isequal(nₜ.h, nₒ.i) throw(ArgumentError("Head index of tail node nₜ ($(nₜ.i)) does not match the index of node nₒ ($(nₒ.i))")) end
    if !isequal(nₒ.h, nₕ.i) throw(ArgumentError("Head index of node nₒ ($(nₒ.i)) does not match the index of head node nₕ ($(nₕ.i))")) end
    if !isequal(nₕ.t, nₒ.i) throw(ArgumentError("Tail index of head node nₕ ($(nₕ.i)) does not match the index of node nₒ ($(nₒ.i))")) end
    A  = s.A 
    aₒ = A[(nₜ.i, nₕ.i)]
    aₜ = A[(nₜ.i, nₒ.i)]
    aₕ = A[(nₒ.i, nₕ.i)]
    nₜ.h = nₕ.i
    nₕ.t = nₜ.i
    nₒ.t = nₒ.i
    nₒ.h = nₒ.i
    s.c -= aₜ.c + aₕ.c - aₒ.c
    return
end