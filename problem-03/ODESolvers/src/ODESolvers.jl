module ODESolvers

include("ProblemTypes.jl")
include("EulerSolver.jl")
include("Physics.jl")
include("ProblemSetup.jl")
include("Visualization.jl")
include("Benchmarks.jl")

import DifferentialEquations


Δh = 0.001

prob_euler = ProblemSetup.prob
sol_euler = EulerSolver.euler_solve(prob_euler, Δh)

prob_ode45 = DifferentialEquations.ODEProblem(prob_euler.ode, prob_euler.u₀, prob_euler.tspan, prob_euler.p)
sol_ode45 = DifferentialEquations.solve(prob_ode45, saveat=Δh)

# sol = sol_ode45
# prob = prob_ode45

# sol = sol_euler
# prob = prob_euler

# Visualization.plot_trajectory_makie(sol_euler, prob)

# Visualization.plot_trajectory_makie(sol_ode45.u, prob)
Visualization.makie_animation(sol_ode45)

# solver::ProblemTypes.Solver = EulerSolver.euler_solve
# problem = ProblemSetup.prob

# step_sizes = 10.0 .^ range(-1, -5, length=5)
# abs_errors = Benchmarks.benchmark(solver, problem, step_sizes)

# Visualization.plot_benchmark_result(step_sizes, abs_errors)

end # module ODESolvers
