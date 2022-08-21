# Insert node nₒ between tail node nₜ and head node nₕ in solution s.
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

# Remove node nₒ from its position between tail node nₜ and head node nₕ in solution s.
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