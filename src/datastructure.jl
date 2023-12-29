"""
    Node(i::Int, x::Float64, y::Float64, t=0, h=0)

A `Node` is a point on the graph at `(x,y)` with index `i`, tail 
node index `t`, and head node index `h`.
"""
mutable struct Node
    i::Int                                                      # Node index
    x::Float64                                                  # Node location on the x-axis
    y::Float64                                                  # Node location on the y-axis
    t::Int                                                      # Tail node index
    h::Int                                                      # Head node index
    Node(i, x, y) = new(i, x, y, 0, 0)
end



"""
    Arc(i::Int, j::Int, c::Float64)

An `Arc` is a connection between nodes `i` and `j` with 
traversal cost `c`.
"""
struct Arc
    i::Int                                                      # Tail node index
    j::Int                                                      # Head node index
    c::Float64                                                  # Cost
end



"""
    Solution(N::Vector{Node}, A::Dict{Tuple{Int,Int}, Arc}, c=0.)

A `Solution` is a graph with nodes `N`, arcs `A`, and route 
cost `c`.
"""
mutable struct Solution
    N::Vector{Node}                                             # Vector of nodes
    A::Dict{Tuple{Int,Int}, Arc}                                # Set of arcs
    c::Float64                                                  # Route cost
    Solution(N, A) = new(N, A, 0.)
end