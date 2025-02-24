module EulerSolver

export euler_solve, euler_solve_in_place

using ..ProblemTypes

# While benchmarking with Benchmark::tail_match, this does not need to save at each Δh
function euler_solve(prob::ProblemTypes.Prob, saveat::Float64)::ProblemTypes.Solution
    # unpack variables
    Δh = saveat

    my_ode = prob.ode
    u₀ = prob.u₀
    tstart, tend = prob.tspan
    p = prob.p

    sol::Vector{ProblemTypes.State} = [u₀]

    # eulers method
    tspan = tstart:Δh:tend
    uₜ = u₀
    for t in tspan
        dₜu = my_ode(uₜ, p, t)
        uₜ = uₜ + Δh * dₜu
        push!(sol, uₜ)
    end
    return sol
end

function euler_solve_in_place(prob::ProblemTypes.Prob)::ProblemTypes.Solution
    # unpack variables
    ode! = prob.ode
    u₀ = prob.u₀
    tstart, tend = prob.tspan
    p = prob.p

    sol::Vector{ProblemTypes.State} = [u₀]

    # eulers method
    Δh = 0.00001
    tspan = tstart:Δh:tend
    uₜ = u₀
    dₜu = [0.0; 0.0; 0.0; 0.0]
    for t in tspan
        dₜu = ode!(dₜu, uₜ, p, t)
        uₜ = uₜ + Δh * dₜu
        push!(sol, uₜ)
    end
    return sol
end

end # module EulerSolver
