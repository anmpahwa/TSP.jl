# Builds instance as graph with set of nodes and arcs.
function build(instance; root=joinpath(dirname(@__DIR__), "instances"))
    # Nodes
    f = joinpath(root, "$instance/nodes.csv")
    csv = CSV.File(f, types=[Int64, Float64, Float64])
    df = DataFrame(csv)
    K = nrow(df)
    N = Vector{Node}(undef, K)
    for k ∈ 1:K N[k] = Node(df[k,1], df[k,2], df[k,3]) end
    # Arcs
    f = joinpath(root, "$instance/arcs.csv")
    csv = CSV.File(f, header=false)
    df = DataFrame(csv)
    A = Dict{Tuple{Int64,Int64},Arc}()
    for i ∈ 1:K for j ∈ 1:K A[(i,j)] = Arc(i, j, df[i,j]) end end
    G = (N, A)
    return G
end