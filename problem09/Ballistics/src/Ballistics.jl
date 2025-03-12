module Ballistics

using DifferentialEquations
using UnPack
using LinearAlgebra
using GLMakie

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
p = Parameters.Param(m=1, g=1, c=1)
prob = ODEProblem(Physics.ballistic!, u0, tspan, p)

function analytical_solve(t)
    m, g, c = p.mass, p.gravity, p.viscosity

    x = x0 + vx0 * ((-m / c) * exp((c / m) * (t0))) * (exp((-c / m) * t) - exp((-c / m) * t0))
    y = y0 + ((vy0 + (m * g / c)) * (-m / c) * (exp((c / m) * t0)) * (exp((-c / m) * t) - exp((-c / m) * t0))) + ((-m * g / c) * (t - t0))
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

time_histories, error_histories = Benchmarks.error_vs_time(prob, analytical_solve)
# Visualization.plot_abs_steps_vs_time(time_histories, error_histories)

(xs, ys, zs) = Benchmarks.tolerances_vs_error(prob, analytical_solve)

fig = Figure(resolution=(1200, 600), fontsize=14)
log_xs = log10.(xs)
log_ys = log10.(ys)
log_zs = log10.(zs)
ax1 = Axis3(fig[1, 1]; 
            aspect=(1, 1, 1), 
            xlabel=L"log_{10}(\text{abstol})", 
            ylabel=L"log_{10}(\text{reltol})", 
            zlabel=L"log_{10}(\text{error})",
            title="3D Error Surface")
ax2 = Axis(fig[1, 2]; 
          aspect=1, 
          xlabel=L"log_{10}(\text{abstol})", 
          ylabel=L"log_{10}(\text{reltol})", 
          title="Error Heatmap")
colormap = :viridis
surf = surface!(ax1, log_xs, log_ys, log_zs; colormap=colormap)
hm = heatmap!(ax2, log_xs, log_ys, log_zs; colormap=colormap)
contour!(ax2, log_xs, log_ys, log_zs; levels=10, color=:black, linewidth=0.5)
cbar = Colorbar(fig[1, 3], hm; label=L"log_{10}(\text{error})")
Label(fig[0, :], "Midpoint Method, Tiny Tolerance vs. Error Analysis", fontsize=20)  # THIS WORKED
min_idx = argmin(log_zs)
scatter!(ax2, [log_xs[min_idx]], [log_ys[min_idx]], color=:red, markersize=15)
save("tolerances_vs_error_combined.png", fig; px_per_unit=2)
display(fig)

end # module Ballistics
