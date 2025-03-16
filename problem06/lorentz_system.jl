using DifferentialEquations
using GLMakie

# ----------------------------
# Define the Lorenz System
# ----------------------------
# The Lorenz system is given by:
#   dx/dt = σ (y - x)
#   dy/dt = x (ρ - z) - y
#   dz/dt = x y - β z
function lorenz!(du, u, p, t)
    σ, ρ, β = p
    du[1] = σ * (u[2] - u[1])
    du[2] = u[1] * (ρ - u[3]) - u[2]
    du[3] = u[1] * u[2] - β * u[3]
end

# ----------------------------
# Set Parameters, Initial Conditions, and Solve the ODE
# ----------------------------
# Typical parameter values for the Lorenz system:
p = (10.0, 28.0, 8 / 3)
u0 = [1.0, 0.0, 0.0]  # initial condition
tspan = (0.0, 40.0)   # simulation time

# Set up the ODE problem and solve it.
prob = ODEProblem(lorenz!, u0, tspan, p)
sol = solve(prob, Tsit5(); saveat = 0.01)

# ----------------------------
# Create the Animation with Makie
# ----------------------------
# Create a new scene with a 3D camera.
scene = Scene(resolution = (800, 600), camera = campixel!)

# Plot the full trajectory as a blue line.
lines!(scene, sol[1, :], sol[2, :], sol[3, :], color = :blue, linewidth = 1)

# Initialize a red marker for the moving point.
# We start with the first position.
point =
    scatter!(scene, [sol[1, 1]], [sol[2, 1]], [sol[3, 1]], markersize = 15, color = :red)

# Record the animation. Here, each frame updates the position of the point.
record(scene, "lorenz_animation.mp4", length(sol.t)) do i
    # Update the marker position to the i-th solution point.
    point[1].attributes[:positions][] = GLMakie.Point3f0(sol[1, i], sol[2, i], sol[3, i])
    # Optionally, you can adjust the frame rate by pausing briefly:
    sleep(0.001)
end

println("Animation saved as lorenz_animation.mp4")
