using TSP
using Revise
using Test
using Random

@testset "TSP.jl" begin
    instances = ["att48", "eil101", "ch150", "d198", "a280"]
    χ   = ALNSParameters(
        k̲   =   1                       ,
        l̲   =   50                      ,
        l̅   =   125                     ,
        k̅   =   250                     ,
        Ψᵣ  =   [
                    :random!    , 
                    :related!   ,
                    :worst!   
                ]                       , 
        Ψᵢ  =   [
                    :best!      ,
                    :greedy!    ,
                    :regret2!   ,
                    :regret3!
                ]                       ,
        Ψₗ  =   [
                    :move!      ,
                    :opt!       ,
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
    for instance ∈ instances
        println("\n Solving $instance")
        sₒ = initialsolution(instance, :cw)     
        S  = ALNS(χ, sₒ)
        s⃰  = S[end]
        @test isfeasible(sₒ)
        @test isfeasible(s⃰)
        @test f(s⃰) ≤ f(sₒ)
    end
    return
end
