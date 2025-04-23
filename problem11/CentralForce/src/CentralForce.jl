module CentralForce

import DifferentialEquations
import GLMakie
import NonlinearSolve
import LinearAlgebra
import NonlinearSolve

include("./Physics.jl")
include("./Visualization.jl")
include("./ProblemSetup.jl")
include("./RootFinding.jl")

function plot_solution(u⃗₀, tend)
    ode_prob = ProblemSetup.create_problem(ProblemSetup.ode!, u⃗₀, tend, ProblemSetup.p)
    sol = DifferentialEquations.solve(ode_prob)
    trajectory = Visualization.plot_trajectory(sol)
    GLMakie.save("./test-plot.png", trajectory)
    GLMakie.display(trajectory)
end

# u⃗₀ = [1.0; 0.0; 0.0; 1.0;]
# tend = 1.0
# plot_solution(ProblemSetup.ode!, u⃗₀, tend, ProblemSetup.p)

periodicorbit = RootFinding.strategy_exponentiate()
u⃗₀ = periodicorbit[1:4]
tend = periodicorbit[5]
plot_solution(u⃗₀, tend)

end # module CentralForce
