"""
    Node(i::Int64, x::Float64, y::Float64, t=i, h=i)

A `Node` is a point on the graph at `(x,y)` with index 
`i`, tail node index `t`, and head node index `h`.
"""
mutable struct Node
    i::Int64                                                    # Node index
    x::Float64                                                  # Node location on the x-axis
    y::Float64                                                  # Node location on the y-axis
    t::Int64                                                    # Tail node index
    h::Int64                                                    # Head node index
    Node(i, x, y) = new(i, x, y, 0, 0)
end



"""
    Arc(i::Int64, j::Int64, c::Float64)

An `Arc` is a connection between node `i` and `j` with traversal cost `c`.
"""
struct Arc
    i::Int64                                                    # Tail node index
    j::Int64                                                    # Head node index
    c::Float64                                                  # Cost
end



"""
    Solution(N::Vector{Node}, A::Dict{Tuple{Int64,Int64}, Arc}, c=0.)

A `Solution` is a graph with nodes `N`, arcs `A`, and TSP route cost `c`.
"""
struct Solution
    N::Vector{Node}                                             # Vector of nodes
    A::Dict{Tuple{Int64,Int64}, Arc}                            # Set of arcs
    c::Float64                                                  # TSP route cost
    Solution(N, A) = new(N, A, 0.)
end