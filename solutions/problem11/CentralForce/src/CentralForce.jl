module CentralForce

hello

import DifferentialEquations
import GLMakie
import NonlinearSolve
import LinearAlgebra
import NonlinearSolve

include("./Physics.jl")
include("./Visualization.jl")
include("./ProblemSetup.jl")
include("./RootFinding.jl")

tol = 1e-12
function plot_solution(u⃗₀, tend)
    ode_prob = ProblemSetup.create_problem(ProblemSetup.ode!, u⃗₀, tend, ProblemSetup.p)
    sol = DifferentialEquations.solve(
        ode_prob,
        DifferentialEquations.Tsit5();
        abstol = tol,
        reltol = tol,
        saveat = 0.01,
    )
    trajectory = Visualization.plot_trajectory(sol)
    GLMakie.save("./trajectory-solution.png", trajectory)
    GLMakie.display(trajectory)
end

# D = 0.001
# θ = π+π/8
# r = 3
# v = 0.01
# vx = -0.35
# vy = 0.09
# r⃗ = [r*cos(θ); r*sin(θ)+0.3]
# v⃗ = [vx; vy]
# u⃗₀ = [r⃗; v⃗]
# tend = 50.0

u⃗₀ = [1.0; 0.0; 0.0; 1.0]
tend = 10.0
plot_solution(u⃗₀, tend)


# tend = 50000.0
# r⃗ = [5, 5]
# v = 5.4225
# v⃗ = [-v, v]
# u⃗₀ = [r⃗; v⃗]
# plot_solution(u⃗₀, tend)

# periodicorbit = RootFinding.strategy_exponentiate()
# u⃗₀ = periodicorbit[1:4]
# tend = periodicorbit[5]
# plot_solution(u⃗₀, tend)


# K = 10
# N = 10
# X = 2
# meshgrid = range(1.0+X, K+X, N)
# meshvel = range(1.0, K, N)
# meshtime = range(1.0, 200, 200)
# periodic_init = []
# epsilon = 1e-1
# count = 0
# tol = 1e-4
# total_iter = (length(meshtime)*length(meshgrid)*length(meshvel))
# for x in meshgrid
#     y = 0
#     vx = 0
#     begin
#         for vy in meshvel
#             for t in meshtime
#                 global count
#                 u⃗₀ = [x, y, vx, vy]
#                 tend = t
#                 ode_prob = ProblemSetup.create_problem(ProblemSetup.ode!, u⃗₀, tend, ProblemSetup.p)
#                 sol = DifferentialEquations.solve(ode_prob, DifferentialEquations.DP5(); abstol=tol, reltol=tol, save_everystep=false)
#                 count+=1
#                 u⃗ₜ = sol.u[end]
#                 Δu⃗₀ = u⃗ₜ - u⃗₀
#                 progress = 100.0*count / total_iter
#                 println(progress, "% progress")
#                 if LinearAlgebra.norm(Δu⃗₀) < epsilon
#                     println("Found periodic orbit")
#                     push!(periodic_init, [u⃗₀; tend])
#                     break
#                 end
#             end
#         end
#     end
# end
# if length(periodic_init) > 0
#     periodicorbit = periodic_init[1]
#     u⃗₀ = periodicorbit[1:4]
#     tend = periodicorbit[5]
#     plot_solution(u⃗₀, tend)
# end

end # module CentralForce
