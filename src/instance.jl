# Builds instance as graph with set of nodes and arcs.
function build(instance; root=joinpath(dirname(@__DIR__), "instances"))
    # Nodes
    df = DataFrame(CSV.File(joinpath(root, "$instance/nodes.csv"), types=[Int64, Float64, Float64]))
    k  = nrow(df)
    K  = 1:k
    N  = Vector{Node}(undef, k)
    for k ∈ K N[k] = Node(df[k,1], df[k,2], df[k,3]) end
    # Arcs
    df = DataFrame(CSV.File(joinpath(root, "$instance/arcs.csv"), header=false))
    A  = Dict{Tuple{Int64,Int64},Arc}()
    for i ∈ K for j ∈ K A[(i,j)] = Arc(i, j, df[i,j]) end end
    G  = (N, A)
    return G
end