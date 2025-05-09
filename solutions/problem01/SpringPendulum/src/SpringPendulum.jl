module SpringPendulum

using DifferentialEquations

include("Parameters.jl")
include("Physics.jl")
include("Visualization.jl")


# problem setup
x₀, y₀ = (1, 0)
r₀ = [x₀; y₀]
v₀ = [1.0; 0.0]
u₀ = [r₀; v₀]
tspan = (0.0, 25.0)
p = Parameters.Param(m = 1, g = 1, c = 0.0, k = 1, l₀ = 1)
prob = ODEProblem(Physics.spring_pendulum!, u₀, tspan, p)


# solver
Δt = 0.001
sol = solve(prob, saveat = Δt, reltol = 1e-6, abstol = 1e-6)


# visualize
# Visualization.plot_trajectory(sol)
Visualization.makie_animation(sol)

end # module SpringPendulum
