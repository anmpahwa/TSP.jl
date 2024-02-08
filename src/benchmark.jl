using TSP
using Revise
using Random
using CPUTime
using DataFrames

let 
    # Define instances
    instances = ["att48", "eil101", "ch150", "d198", "a280"];
    # Define random number generators
    seeds = [1010, 1104, 1509, 1604, 1905, 2104, 2412, 2703, 2710, 2807]
    # Dataframes to store solution quality and run time
    df₁ = DataFrame([instances, [zeros(length(instances)) for _ ∈ seeds]...], [iszero(i) ? "instance" : "$(seeds[i])" for i ∈ 0:length(seeds)])
    df₂ = DataFrame([instances, [zeros(length(instances)) for _ ∈ seeds]...], [iszero(i) ? "instance" : "$(seeds[i])" for i ∈ 0:length(seeds)])
    for i ∈ eachindex(instances)
        instance = instances[i]
        # Visualize instance
        display(visualize(instance))
        for j ∈ eachindex(seeds)
            seed = seeds[j]
            println("\n instance: $instance | seed: $seed")
            rng = MersenneTwister(seed);
            # Define inital solution method and build the initial solution
            s₁ = initialize(instance);
            # Visualize initial solution
            display(visualize(s₁)) 
            # Define ALNS parameters
            x = max(100, lastindex(s₁.N))
            χ = ALNSparameters(
                j   =   50                      ,
                k   =   5                       ,
                n   =   x                       ,
                m   =   100x                    ,
                Ψᵣ  =   [
                            :randomnode!        ,
                            :relatednode!       ,
                            :worstnode!
                        ]                       ,
                Ψᵢ  =   [
                            :best!              ,
                            :precise!           ,
                            :perturb!           ,
                            :regret2!           ,
                            :regret3!
                        ]                       ,
                Ψₗ  =   [
                            :move!              ,
                            :swap!              ,
                            :opt!
                        ]                       ,
                σ₁  =   15                      ,
                σ₂  =   10                      ,
                σ₃  =   3                       ,
                μ̲   =   0.1                     ,
                c̲   =   4                       ,
                μ̅   =   0.4                     ,
                c̅   =   60                      ,
                ω̅   =   0.05                    ,
                τ̅   =   0.5                     ,
                ω̲   =   0.01                    ,
                τ̲   =   0.01                    ,
                θ   =   0.9985                  ,
                ρ   =   0.1
            );
            # Run ALNS and fetch best solution
            t = @CPUelapsed s₂ = ALNS(rng, χ, s₁);
            # Fetch objective function values
            println("Initial: $(round(s₁.c, digits=3))")
            println("Optimal: $(round(s₂.c, digits=3))")
            # Check if the solutions are feasible
            println("Solution feasibility:")
            println("   Initial: $(isfeasible(s₁))")
            println("   Optimal: $(isfeasible(s₂))")
            # Visualize best solution   
            display(visualize(s₂))
            # Store Results
            df₁[i,j+1] = f(s₂)
            df₂[i,j+1] = t
            println(df₁)
            println(df₂)
        end
    end
    return
end