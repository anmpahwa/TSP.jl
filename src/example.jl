using TSP
using Revise
using Random

let
# Developing an optimal TSP route 
    # Define instance
    instance = "a280";
    # Visualize instance
    display(visualize(instance))
    # Define a random number generator
    rng = MersenneTwister(1104);
    # Define inital solution method and build the initial solution
    G  = build(instance)
    sₒ = initialsolution(rng, G, :random);
    # Define ALNS parameters
    x = length(sₒ.N);
    n = max(500, ceil(x, digits=-(length(digits(x))-1)));
    χ   = ALNSParameters(
        n   =   n ÷ 25                  ,
        k   =   250                     ,
        m   =   2n                      ,
        j   =   125                     ,
        Ψᵣ  =   [
                    :randomnode!    ,
                    :relatednode!   ,
                    :worstnode!
                ]                       ,
        Ψᵢ  =   [
                    :best!          ,
                    :precise!       ,
                    :perturb!       ,
                    :regret2!       ,
                    :regret3!
                ]                       ,
        Ψₗ  =   [
                    :move!      ,
                    :opt!       ,
                    :swap!
                ]                       ,
        σ₁  =   15                      ,
        σ₂  =   10                      ,
        σ₃  =   3                       ,
        ω   =   0.05                    ,
        τ   =   0.5                     ,
        𝜃   =   0.9975                  ,
        C̲   =   4                       ,
        C̅   =   60                      ,
        μ̲   =   0.1                     ,
        μ̅   =   0.4                     ,
        ρ   =   0.1                     ,
    );
    # Run ALNS and fetch best solution
    S = ALNS(rng, χ, sₒ);
    s⃰ = S[end];
# Fetch objective function values
    println("Initial: $(f(sₒ))")
    println("Optimal: $(f(s⃰))")
# Visualizations
    # Visualize initial solution
    display(visualize(sₒ)) 
    # Visualize best solution   
    display(visualize(s⃰))
    # Animate ALNS solution search process from inital to best solution
    display(animate(S))
    # Show convergence plot
    display(pltcnv(S))
    return
end