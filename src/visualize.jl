"""
    visualize(instance; root=joinpath(dirname(@__DIR__), "instances"), backend=gr)

Plots `instance`.
Uses given `backend` to plot (defaults to `gr`).
"""
function visualize(instance; root=joinpath(dirname(@__DIR__), "instances"), backend=gr)
    backend()
    G = build(instance; root=root)
    N, _ = G
    fig = plot(legend=:none)
    I = eachindex(N)
    W = fill("color",  I)
    X = zeros(Float64, I)
    Y = zeros(Float64, I)
    for i ∈ I
        n = N[i]
        W[i] = "LightBlue"
        X[i] = n.x
        Y[i] = n.y
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
    K = length(V)
    W = fill("color",  K)
    X = zeros(Float64, K)
    Y = zeros(Float64, K)
    for k ∈ 1:K
        i = V[k]
        n = N[i]
        W[k] = "DarkBlue"
        X[k] = n.x
        Y[k] = n.y
    end
    scatter!(X, Y, markersize=4, markerstrokewidth=0, color=W)
    plot!(X, Y, color="SteelBlue")
    # Open nodes
    V = [n.i for n ∈ N if isopen(n)]
    K = length(V)
    W = fill("color",  K)
    X = zeros(Float64, K)
    Y = zeros(Float64, K)
    for k ∈ 1:K
        i = V[k]
        n = N[i]
        W[k] = "LightBlue"
        X[k] = n.x
        Y[k] = n.y
    end
    scatter!(X, Y, markersize=4, markerstrokewidth=0, color=W)
    # Annotation
    x = minimum(getproperty.(N, :x))
    y = maximum(getproperty.(N, :y))
    annotate!(x, y, text("f(s): $(Int64(round(f(s))))", :left, 10))
    return fig
end

"""
    animate(S::Vector{Solution}; fps=10)

Iteratively plots solutions in `S` to develop a gif at given `fps`.
"""
function animate(S::Vector{Solution}; fps=10)
    K = 0:(length(S)-1)
    figs = Vector(undef, length(S))
    for (k,s) ∈ pairs(S)
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