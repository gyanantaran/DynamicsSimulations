module SimplestDynamicsPolar

using DifferentialEquations
using LinearAlgebra
using GLMakie

# Physics: ODE
function acceleration_zero_polar!(du, u, p, t)
    r  = u[1]
    vᵣ = u[2] 
    θ  = u[3]
    ω  = u[4]

    du[1] = vᵣ
    du[2] = r * ω^2
    du[3] = ω
    du[4] = -2 * r^(-1) * vᵣ * ω
end

# Problem setup
r₀ = 2
θ₀ = π/3
v⃗ = [1;2]

êᵣ₀ = [cos(θ₀); sin(θ₀)]
êₚ₀ = [-sin(θ₀); cos(θ₀)]

vᵣ₀ = dot(v⃗, êᵣ₀)
vₚ₀ = dot(v⃗ - vᵣ₀ * êᵣ₀, êₚ₀)

ω₀ = vₚ₀ / r₀

u₀ = [r₀; vᵣ₀; θ₀; ω₀]
tspan = (0.0, 10.0)
p = nothing

prob = ODEProblem(acceleration_zero_polar!, u₀, tspan, p)

# Numerical solution
Δh = 0.5
sol = solve(prob, saveat=Δh, abstol=1, reltol=1)

# Measuring straightness
function norm_expected_straight_endpoint(p⃗)
    Δt = tspan[2] - tspan[1]
    v⃗_cartesian = vᵣ₀ .* êᵣ₀ + vₚ₀ .* êₚ₀
    p̂ = r₀ .* [cos(θ₀); sin(θ₀)] .+ v⃗_cartesian .* Δt
    s⃗ = p⃗ .- p̂
    e = norm(s⃗)
    return e
end

# Plotting trajectories
function plot_trajectory_makie(sol)
    # Convert solution to matrix form
    sol_matrix = reduce(hcat, sol.u)'
    
    r = sol_matrix[:, 1]
    θ = sol_matrix[:, 3]

    r⃗ = r .* [cos.(θ) sin.(θ)]
    x = r⃗[:, 1]
    y = r⃗[:, 2]
    xlimits = (minimum(x)-5, maximum(x)+5)
    ylimits = (minimum(y)-5, maximum(y)+5)

    ω = sol_matrix[:, 4]
    vᵣ = sol_matrix[:, 2]
    vₚ = ω .* r
    v⃗ = [vᵣ vₚ]
    s = norm.([v⃗[i, :] for i in 1:length(length(v⃗))])
    t = sol.t

    # Create figure
    fig = GLMakie.Figure()
    ax1 = GLMakie.Axis(fig[1, 1], xlabel="x", ylabel="y", limits=(xlimits, ylimits), aspect = DataAspect())
    ax2 = GLMakie.Axis(fig[1, 2], xlabel="time", ylabel="speed", aspect = DataAspect())

    GLMakie.lines!(ax1, x, y)
    GLMakie.lines!(ax2, t, s)
    # GLMakie.save("problem08-trajectory.png", fig)
    GLMakie.display(fig)
    return nothing
end
# plot_trajectory_makie(sol)

# Plotting straightness metric
function plot_error()
    step_sizes = 10.0 .^ range(-1, -5, length=5)
    solution_ends = [solve(prob, saveat=step_size).u[end] for step_size in step_sizes]
    sol_end_matrix = reduce(hcat, solution_ends)'

    r = sol_end_matrix[:, 1]
    θ = sol_end_matrix[:, 3]


    p⃗_list = r .* [cos.(θ) sin.(θ)]
    errors = [norm_expected_straight_endpoint(p⃗_list[i, :]) for i in 1:size(p⃗_list)[1]]

    log_step_sizes = log.(step_sizes)
    log_errors = log.(errors)
   
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], xlabel="log(step_sizes)", ylabel="log(errors)")

    GLMakie.lines!(ax, log_step_sizes, log_errors)
    GLMakie.save("problem08-error.png", fig)
    GLMakie.display(fig)
    return nothing
end
plot_error()


end # module SimplestDynamicsPolar
