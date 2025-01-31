module Ballistics

using DifferentialEquations;
using Plots;

include("Parameters.jl");
include("Physics.jl");
include("Visualization.jl")

# problem setup
r0 = [0.0;0.0];
speed0 = 1000; launchangle = pi/4;
v0 = speed0 * [cos(launchangle); sin(launchangle)];
u0 = [r0;v0];
tspan = (0.0,100.0);
p = Parameters.Param(m=1,g=1,c=1);
prob = ODEProblem(Physics.ballistic!, u0, tspan, p);

# solver
sol = solve(prob);

# visualize
Visualization.plot_trajectory(sol)

end # module Ballistics
