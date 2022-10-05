"""
    visualize(instance; backend=gr)

Plots `instance`.
Uses given `backend` to plot (defaults to `gr`).
"""
function visualize(instance; backend=gr)
    backend()
    G = build(instance)
    N, _ = G
    fig = plot(legend=:none)
    I = eachindex(N)
    X = zeros(Float64, I)
    Y = zeros(Float64, I)
    W = fill("color", I)
    for i ∈ I
        n = N[i]
        X[i] = n.x
        Y[i] = n.y
        W[i] = "LightBlue"
    end
    scatter!(X, Y, markersize=4, markerstrokewidth=0, color=W)
    return fig
end
"""
    visualize(s::Solution; backend=gr)

Plots solution `s` depicting route and unvisited nodes (if any).
Uses given `backend` to plot (defaults to `gr`).
"""
function visualize(s::Solution; backend=gr)
    backend()
    N = s.N
    fig = plot(legend=:none)
    # Closed nodes
    V = vectorize(s)
    Z = V
    K = length(Z)
    X = zeros(Float64, K)
    Y = zeros(Float64, K)
    W = fill("color", K)
    for k ∈ 1:K
        i = Z[k]
        n = N[i]
        X[k] = n.x
        Y[k] = n.y
        W[k] = "DarkBlue"
    end
    scatter!(X, Y, markersize=4, markerstrokewidth=0, color=W)
    plot!(X, Y, color="SteelBlue")
    # Open nodes
    L  = [n.i for n ∈ N if isopen(n)]
    Z′ = L
    K′ = length(Z′)
    X′ = zeros(Float64, K′)
    Y′ = zeros(Float64, K′)
    W′ = fill("color", K′)
    for k ∈ 1:K′
        i = Z′[k]
        n = N[i]
        X′[k] = n.x
        Y′[k] = n.y
        W′[k] = "LightBlue"
    end
    scatter!(X′, Y′, markersize=4, markerstrokewidth=0, color=W′)
    # Annotation
    x = minimum(getproperty.(N, :x))
    y = maximum(getproperty.(N, :y))
    annotate!(x, y, text("f(s): $(Int64(round(f(s))))", :left, 10))
    return fig
end

"""
    vectorize(s::Solution)

Returns solution as a sequence of nodes in the order of visits.
"""
function vectorize(s::Solution)
    N = s.N
    d = N[1]
    V = Int64[]
    if isopen(d) return V end
    nₜ = d
    nₕ = N[nₜ.h]
    push!(V, d.i)
    while true
        push!(V, nₕ.i)
        if isequal(nₕ, d) break end
        nₜ = nₕ
        nₕ = N[nₜ.h]
    end
    return V
end

"""
    animate(S::Vector{Solution}; fps=10)

Iteratively plots solutions in `S` to develop a gif at given `fps`.
"""
function animate(S::Vector{Solution}; fps=10)
    K = 0:(length(S)-1)
    figs = Vector(undef, length(S))
    for (k, s) ∈ enumerate(S)
        fig = visualize(s, backend=gr)
        plot!(title="Iteration #$(K[k])", titlefontsize=11)
        figs[k] = fig
    end
    anim = @animate for fig in figs
        plot(fig)
    end
    gif(anim, fps=fps, show_msg=false)
end

"""
    pltcnv(S::Vector{Solution}; backend=gr)

Plots objective function values for solutions in `S`.
Uses given `backend` to plot (defaults to `gr`).
"""
function pltcnv(S::Vector{Solution}; backend=gr)
    backend()
    Y = [f(s) for s ∈ S]
    X = 0:(length(S)-1)
    fig = plot(legend=:none)
    plot!(X,Y, xlabel="iterations", ylabel="objective function value")
    return fig
end