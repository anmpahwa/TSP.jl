using TSP
using Revise
using Test
using Random

@testset "TSP.jl" begin
    K = 5
    instances = ["att48", "eil101", "ch150", "d198", "a280"]
    methods = [:cw_init, :nn_init, :random_init, :regret₂init, :regret₃init]
    χ   = ALNSParameters(
        k̲   =   1                       ,
        l̲   =   50                      ,
        l̅   =   125                     ,
        k̅   =   250                     ,
        Ψᵣ  =   [
                    :random_remove! , 
                    :shaw_remove!   ,
                    :worst_remove!   
                ]                       , 
        Ψᵢ  =   [
                    :best_insert!   ,
                    :greedy_insert! ,
                    :regret₂insert! ,
                    :regret₃insert!
                ]                       ,
        Ψₗ  =   [
                    :move!          ,
                    :opt!           ,
                    :swap!
                ]                       ,
        σ₁  =   33                      ,
        σ₂  =   9                       ,
        σ₃  =   13                      ,
        ω   =   0.05                    ,
        τ   =   0.5                     ,
        𝜃   =   0.99975                 ,
        C̲   =   30                      ,
        C̅   =   60                      ,
        μ̲   =   0.1                     ,
        μ̅   =   0.4                     ,
        ρ   =   0.1                     ,
    )
    for k ∈ 1:K
        instance = instances[k]
        method = methods[k]
        println("\n Solving $instance")
        G = build(instance)
        sₒ= initialsolution(G, method)     
        @test isfeasible(sₒ)
        S = ALNS(χ, sₒ)
        s⃰ = S[end]
        @test isfeasible(s⃰)
        @test f(s⃰) ≤ f(sₒ)
    end
    return
end
