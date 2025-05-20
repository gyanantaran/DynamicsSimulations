module FindEquilibrium

import DifferentialEquations
import GLMakie

include("./Physics.jl")
include("Visualization.jl")

struct SpringParameters
    k::Float64          # constant
    l::Float64          # restlen
    r⃗₀::Vector{Float64} # anchor point
    c::Float64          # damp: dashpot
end

struct Parameters
    m::Float64
    g::Float64
    c_d::Float64
    spring1::SpringParameters
    spring2::SpringParameters
end

p = Parameters(
    (global m = 0.1),
    (global g = 0.1),
    (global c_d = 0.5),
    (global spring1 = SpringParameters(
        (global k1=2.0),
        (global l1=2.0),
        (global r⃗₁=[1.0, 0.0]),
        (global c1=1.0),
        )
    ),
    (global spring2 = SpringParameters(
        (global k2=1.0),
        (global l2=0.5),
        (global r⃗₂=[-1.0, -1.0]),
        (global c2=1.0),
        )
    ),
)

tspan = (
    (global tstart=0.0),
    (global tend=200.0)
)

u⃗₀ = [
    (global r0=[-1.0;1.0]);
    (global v0=[10.0;5.0]);
]

odefunc = Physics.twospringsdragdamped!
odeprob = DifferentialEquations.ODEProblem(
    odefunc,
    u⃗₀,
    tspan,
    p,
    )

trajectory = GLMakie.Figure()
trajectory_lines = GLMakie.Axis(
    trajectory[1,1],
    title="Trajectory",
    aspect=GLMakie.DataAspect(),
)

# i = [1.0;0.0]
# j = [0.0;1.0]
# N, n = 30, 5
# Δr⃗₀s = (global ϵ=0.01)*[cos(θ)*i+sin(θ)*j for θ in range(0.0; step=2π/N, length=n)]

# Δd = abs.(r⃗₁ - r⃗₂)
# Δt = 0.1
# for x in range(min(r⃗₁[1], r⃗₂[1]) - Δd[1], max(r⃗₁[1], r⃗₂[1]) + Δd[2], length=N)
#     for y in range(min(r⃗₁[2], r⃗₂[2]) - Δd[2], max(r⃗₁[2], r⃗₂[2]) + Δd[2], length=N)
#         u⃗₀ = [
#             [x;y];
#             [0.0;0.0];
#         ]
#         for Δr⃗₀ in Δr⃗₀s
#             u⃗₀_modified = u⃗₀ + [Δr⃗₀; Δr⃗₀]
#             odeprob = DifferentialEquations.ODEProblem(
#                 odefunc,
#                 u⃗₀_modified,
#                 tspan,
#                 p,
#             )
#             sol = DifferentialEquations.solve(
#                 odeprob; 
#                 # saveat=Δt,
#                 save_everystep=false,
#                 )
#             # Visualization.plot_trajectory!(trajectory, sol)
#             # Visualization.plot_start_end!(trajectory, sol)
#             Visualization.plot_end!(trajectory, sol)
#         end
#     end
# end

Δt = 0.01
sol = DifferentialEquations.solve(
    odeprob; 
    saveat=Δt,
    )
Visualization.plot_trajectory!(trajectory, sol)
Visualization.plot_points!(trajectory, spring1.r⃗₀, spring2.r⃗₀)

end # module FindEquilibrium
