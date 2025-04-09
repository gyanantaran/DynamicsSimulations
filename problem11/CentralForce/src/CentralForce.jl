module CentralForce

import DifferentialEquations
import GLMakie
import NonlinearSolve

include("./Physics.jl")
include("./Visualization.jl")
include("./ProblemSetup.jl")

struct Param
    m::Float64
    k::Float64
end

u⃗₀ = [1.0; 1.0; 0.0; 1.0]
tend = 50.0
m = 1.0
k = 1.0
p = Param(m, k)
# ode! = Physics.create_ode(Physics.dipolepowerlaw)
ode! = Physics.create_ode(Physics.speedindependentofradius)

# ode_prob = ProblemSetup.create_problem(ode!, u⃗₀, tend, p)
# sol = DifferentialEquations.solve(ode_prob)
# trajectory = Visualization.plot_trajectory(sol)
# GLMakie.save("./problem11_trajectory_central_force.png", trajectory)
# GLMakie.display(trajectory)

function f(z⃗₀, p)
    u⃗₀ = z⃗₀[1:end-1]
    t = z⃗₀[end]
    dynamics_prob = ProblemSetup.create_problem(ode!, u⃗₀, t, p)
    dynamics_sol = DifferentialEquations.solve(dynamics_prob; reltol=1e-6, abstol=1e-6, save_everystep=false)
    u⃗ₜ = dynamics_sol.u[end]
    Δu⃗ = u⃗ₜ - u⃗₀
    return Δu⃗
end
z⃗₀ = [1.0;0.0;0.1;1.0;10.0]
root_prob = NonlinearSolve.NonlinearProblem(f, z⃗₀, p)
root_sol = NonlinearSolve.solve(root_prob)


# plot the periodic solution
u⃗₀ = root_sol[1:end-1]
tend = root_sol[end]

ode_prob = ProblemSetup.create_problem(ode!, u⃗₀, tend, p)
sol = DifferentialEquations.solve(ode_prob)
trajectory = Visualization.plot_trajectory(sol)
GLMakie.save("./problem11_trajectory_periodic.png", trajectory)
GLMakie.display(trajectory)

end # module CentralForce
