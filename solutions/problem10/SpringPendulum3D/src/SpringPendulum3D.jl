module SpringPendulum3D

using DifferentialEquations
using GLMakie

include("Parameters.jl")
include("Physics.jl")
include("Visualization.jl")


# problem setup
x₀, y₀, z₀ = (1, 0, 0)
r₀ = [x₀; y₀; z₀]
v₀ = [0.0; 1.0; 0.0]
u₀ = [r₀; v₀]
tspan = (0.0, 10.0)
p = Parameters.Param(m = 1, g = 1, k = 2, l₀ = 0)
prob = ODEProblem(Physics.spring_pendulum3d!, u₀, tspan, p)


# solver
sol = solve(prob, reltol = 1e-6, abstol = 1e-6)


# visualize

# trajectory_plot = Visualization.plot_trajectory3D(sol)
# GLMakie.save("trajectory_plot.png", trajectory_plot)

trajectory_plot = Visualization.plot_trajectory_projections(sol)
GLMakie.save("trajectory_plot_projection.png", trajectory_plot)

GLMakie.display(trajectory_plot)

# Visualization.makie_animation3D(sol)



end # module SpringPendulum3D
