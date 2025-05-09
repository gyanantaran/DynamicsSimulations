module Ballistics

using DifferentialEquations
using UnPack
using LinearAlgebra
using GLMakie
using Infinity

include("Parameters.jl")
include("Physics.jl")
include("Visualization.jl")
include("Benchmarks.jl")

# problem setup
x0, y0 = 0.0, 0.0
r0 = [x0; y0]
speed0 = 1
launchangle = pi / 4
vx0, vy0 = speed0 * [cos(launchangle); sin(launchangle)]
v0 = [vx0; vy0]
u0 = [r0; v0]

t0 = 0.0
tend = 1.0
tspan = (t0, tend)
p = Parameters.Param(m = 1, g = 1, c = 1)
prob = ODEProblem(Physics.ballistic!, u0, tspan, p)

function analytical_solve(t)
    m, g, c = p.mass, p.gravity, p.viscosity

    x =
        x0 +
        vx0 * ((-m / c) * exp((c / m) * (t0))) * (exp((-c / m) * t) - exp((-c / m) * t0))
    y =
        y0 +
        (
            (vy0 + (m * g / c)) *
            (-m / c) *
            (exp((c / m) * t0)) *
            (exp((-c / m) * t) - exp((-c / m) * t0))
        ) +
        ((-m * g / c) * (t - t0))
    vx = (vx0) * (exp((-c / m) * (t - t0)))
    vy = ((vy0) + (m * g / c)) * exp((-c / m) * (t - t0)) - (m * g / c)

    u = zeros((4,))
    u[1] = x
    u[2] = y
    u[3] = vx
    u[4] = vy

    return u
end

# solver
# Δh = 0.1
# sol_numeric = solve(prob, Midpoint(), dt=Δh, adaptive=false)
# sol_analytical = analytical_solve.(t0:Δh:tend)

# visualize
# Visualization.plot_trajectory(sol_numeric.u)
# Visualization.plot_both_trajectory(sol_numeric.u, sol_analytical)
# Visualization.plot_both_position(sol_numeric.u, sol_analytical)
# Visualization.plot_both_velocity(sol_numeric.u, sol_analytical)


# log_steps, log_errors_dict = Benchmarks.abs_error_vs_step_sizes(prob, analytical_solve)
# Visualization.plot_abs_steps_vs_error(log_steps, log_errors_dict)

# time_histories, error_histories = Benchmarks.error_vs_time(prob, analytical_solve)
# Visualization.plot_abs_steps_vs_time(time_histories, error_histories)

# (xs, ys, zs) = Benchmarks.tolerances_vs_error(prob, analytical_solve)
# Visualization.plot_tolerances_vs_error(xs, ys, zs)


function solve_till_empty(prob)
    conditionatbeggining(u, t, integrator) = t > 0
    removetstop!(integrator) = add_tstop!(integrator, ∞)
    removetstopwhenbeginning = DiscreteCallback(conditionatbeggining, removetstop!)

    condition(u, t, integrator) = u[2] < 0
    affect!(integrator) = terminate!(integrator)
    stopwhenonground = DiscreteCallback(condition, affect!)

    cb = CallbackSet(removetstopwhenbeginning, stopwhenonground)
    sol = solve(prob, RK4(), callback = cb, tstops = [0.1])

    sol
end

function problem_setup(launchangle, speed0, c)
    x0, y0 = 0.0, 0.0
    r0 = [x0; y0]
    vx0, vy0 = speed0 * [cos(launchangle); sin(launchangle)]
    v0 = [vx0; vy0]
    u0 = [r0; v0]

    t0 = 0.0
    tend = 1.0
    tspan = (t0, tend)
    p = Parameters.Param(m = 1, g = 1, c = c)
    prob = ODEProblem(Physics.ballistic!, u0, tspan, p)
    return prob
end


# speeds = range(0, 100)
# problems = problem_setup.(Ref(pi/4), speeds, Ref(1))
# sols = solve_till_empty.(problems)
# Visualization.plot_all_trajectories(sols)

function best_angle_for_speed(speed0, c)
    launchangles = pi / 4 .* ((range(-1.0, 1.0, 300)) .^ 3.0 .+ 1.0)

    max_range = 0
    argmax_theta = 0
    for launchangle in launchangles
        # problem setup
        prob = problem_setup(launchangle, speed0, c)

        sol = solve_till_empty(prob)
        cur_range = sol.u[end][1]
        if cur_range > max_range
            max_range = cur_range
            argmax_theta = launchangle
        end
    end
    argmax_theta
end

# speeds = 10.0 .^ range(0.0, 3.1, 100)
# bestangles = []
# for speed0 in speeds
#     bestangle = best_angle_for_speed(speed0, 10)
#     push!(bestangles, bestangle)
# end
# Visualization.plot_best_angle_vs_speed(speeds, bestangles)


# speed0 = 1200.0
# bestangles = []
# drags = 2.0 .^ range(1.0, 5.0)
# for c in drags
#     bestangle = best_angle_for_speed(speed0, c)
#     push!(bestangles, bestangle)
# end
# Visualization.plot_best_angle_vs_drag(drags, bestangles)

end # module Ballistics
