# Builds instance as graph with set of nodes and arcs.
function build(instance)
    # Nodes
    df = DataFrame(CSV.File(joinpath(dirname(@__DIR__), "instances/$instance/nodes.csv")))
    k  = nrow(df)
    K  = 1:k
    N  = Vector{Node}(undef, k)
    for k ∈ K N[k] = Node(df[k,1], df[k,2], df[k,3]) end
    # Arcs
    df = DataFrame(CSV.File(joinpath(dirname(@__DIR__), "instances/$instance/arcs.csv"), header=false))
    A  = Dict{Tuple{Int64,Int64},Arc}()
    for i ∈ K for j ∈ K A[(i,j)] = Arc(i, j, df[i,j]) end end
    G  = (N, A)
    return G
end