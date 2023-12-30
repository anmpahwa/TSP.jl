"""
    visualize(instance; root=joinpath(dirname(@__DIR__), "instances"), backend=gr)

Plots `instance`.
Uses given `backend` to plot (defaults to `gr`).
"""
function visualize(instance; backend=gr)
    backend()
    G = build(instance)
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
    K = eachindex(V)
    W = fill("color",  K)
    X = zeros(Float64, K)
    Y = zeros(Float64, K)
    for k ∈ K
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
    K = eachindex(V)
    W = fill("color",  K)
    X = zeros(Float64, K)
    Y = zeros(Float64, K)
    for k ∈ K
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
    annotate!(x, y, text("f(s): $(Int(round(f(s))))", :left, 10))
    return fig
end



"""
    animate(S::OffsetVector{Solution}; fps=10)

Iteratively plots solutions in `S` to develop a gif at given `fps`.
"""
function animate(S::OffsetVector{Solution}; fps=1)
    s⃰ = S[0]
    z⃰ = f(s⃰)
    figs = []
    for k ∈ eachindex(S)
        s = S[k]
        z = f(s)
        if z < 0.99z⃰ 
            s⃰ = s
            z⃰ = z
            fig = visualize(s⃰, backend=gr)
            plot!(title="Iteration #$k", titlefontsize=11)
            push!(figs, fig)
        end
    end
    anim = @animate for fig ∈ figs
        plot(fig)
    end
    gif(anim, fps=fps, show_msg=false)
end



"""
    pltcnv(Z::OffsetVector{Float64}; backend=gr)

Plots convergence using objective function evaluations vector `Z`. 
Uses given `backend` to plot (defaults to `gr`).
"""
function pltcnv(Z::OffsetVector{Float64}; backend=gr)
    backend()
    fig= plot(legend=:none)
    Y₁ = Int[]
    z⃰  = Z[0]
    for (k, z) ∈ pairs(Z)
        if z < 0.99z⃰ 
            z⃰ = z
            push!(Y₁, k)
        end
    end
    vline!(Y₁, color=:black, linewidth=0.25)
    Y₂ = zeros(eachindex(Z))
    z⃰  = minimum(Z)
    for (k, z) ∈ pairs(Z)
        Y₂[k] = (z/z⃰ - 1) * 100 
    end
    X = eachindex(Z)
    plot!(X, Y₂, xlabel="iterations", ylabel="deviation from the best (%)", color=:steelblue)
    return fig
end