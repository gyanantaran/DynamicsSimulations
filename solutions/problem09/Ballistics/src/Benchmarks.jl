module Benchmarks

using DifferentialEquations
using LinearAlgebra

# Abs error for various step sizes
function abs_error_vs_step_sizes(prob, analytical_solve)
    # step_sizes = 10.0 .^ range(-1, -15, step=-1)
    step_sizes = 10.0 .^ range(-1, -5, step = -1)
    abs_errors_midpoint = Vector{Float64}(undef, length(step_sizes))
    abs_errors_rk4 = Vector{Float64}(undef, length(step_sizes))

    for (i, Δh) in enumerate(step_sizes)
        sol_numeric_midpoint =
            solve(prob, Midpoint(), dt = Δh, adaptive = false, save_everystep = false)[end]
        sol_numeric_rk4 =
            solve(prob, RK4(), dt = Δh, adaptive = false, save_everystep = false)[end]
        tend = prob.tspan[2]
        sol_analytic = analytical_solve(tend)

        separation_midpoint = sol_numeric_midpoint - sol_analytic
        separation_rk4 = sol_numeric_rk4 - sol_analytic
        error_midpoint = norm(separation_midpoint)
        error_rk4 = norm(separation_rk4)

        abs_errors_midpoint[i] = error_midpoint
        abs_errors_rk4[i] = error_rk4
    end

    log_errors_midpoint = log10.(abs_errors_midpoint)
    log_errors_rk4 = log10.(abs_errors_rk4)
    log_errors_dict = Dict("midpoint" => log_errors_midpoint, "rk4" => log_errors_rk4)
    log_steps = log10.(step_sizes)

    return log_steps, log_errors_dict
end

# Abs error for all times
function error_vs_time(prob, analytical_solve)
    N = 5
    step_sizes = 10.0 .^ range(-1, -N, step = -1)
    time_histories = Vector{Vector{Float64}}(undef, length(step_sizes))
    error_histories = Vector{Vector{Float64}}(undef, length(step_sizes))
    for (i, Δh) in enumerate(step_sizes)
        sol = solve(prob, Midpoint(), dt = Δh, adaptive = false, save_everystep = true)

        timestamps = sol.t
        sol_numeric_midpoint = sol.u
        sol_analytic = analytical_solve.(timestamps)

        separations = sol_numeric_midpoint .- sol_analytic
        manhatten_errors = norm.(separations, Ref(1))
        error_histories[i] = log10.(manhatten_errors)
        time_histories[i] = timestamps
    end
    return time_histories, error_histories
end


function tolerances_vs_error(prob, analytical_solve)
    N = 15
    error_matrix = Matrix{Float64}(undef, N, N)
    num_granularity = N + 7
    abstols = 10.0 .^ range(7, -N, length = num_granularity)
    reltols = 10.0 .^ range(7, -N, length = num_granularity)

    num_samples = length(abstols) * length(reltols)

    xs = Vector{Float64}(undef, num_samples)
    ys = Vector{Float64}(undef, num_samples)
    zs = Vector{Float64}(undef, num_samples)

    for (i, abstol) in enumerate(abstols)
        for (j, reltol) in enumerate(reltols)
            sol_numeric = solve(
                prob,
                Midpoint(),
                adaptive = true,
                save_everystep = false,
                abstol = abstol,
                reltol = reltol,
            )[end]
            sol_analytic = analytical_solve(prob.tspan[2])

            separation = sol_numeric - sol_analytic
            error = norm(separation)
            xs[i+num_granularity*(j-1)] = abstol
            ys[i+num_granularity*(j-1)] = reltol
            zs[i+num_granularity*(j-1)] = error
        end
    end
    xs, ys, zs
end

end # module Benchmarks
