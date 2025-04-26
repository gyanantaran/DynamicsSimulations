module RootFinding

import NonlinearSolve
import DifferentialEquations
import LinearAlgebra

import ..ProblemSetup
import ..Physics


f(z⃗₀, p) = begin
    tol = 1e-12
    u⃗₀ = z⃗₀[1:(end-1)]
    tend = z⃗₀[end]
    dynamics_prob = ProblemSetup.create_problem(ProblemSetup.ode!, u⃗₀, tend, p)
    dynamics_sol = DifferentialEquations.solve(
        dynamics_prob;
        abstol = tol,
        reltol = tol,
        save_everystep = false,
    )
    u⃗ₜ = dynamics_sol.u[end]
    Δu⃗ = u⃗ₜ - u⃗₀
    phasecondition = u⃗₀[2] # crosses the x axis
    # v⃗₀ = u⃗₀[3:4]
    # limit = 0.1
    # if LinearAlgebra.norm(v⃗₀) < limit || tend < 0.1
    #     return zeros(5) .+ 1.0
    # end
    # Δu⃗
    return [Δu⃗; phasecondition]
end

# f(z⃗₀, p) = begin
#     # Use a slightly more forgiving tolerance
#     tol = 1e-10
#     u⃗₀ = z⃗₀[1:end-1]
#     tend = z⃗₀[end]
#     # Safeguard against problematic integration times
#     if tend < 0.01 || tend > 100.0
#         return ones(5) * 1e6  # Return large values to push solver away
#     end
#     # Check for reasonable velocity values
#     v⃗₀ = u⃗₀[3:4]
#     if LinearAlgebra.norm(v⃗₀) < 0.1 || LinearAlgebra.norm(v⃗₀) > 100.0
#         return ones(5) * 1e6
#     end
#     # Try using a stiff solver explicitly
#     dynamics_prob = ProblemSetup.create_problem(ProblemSetup.ode!, u⃗₀, tend, p)
#     dynamics_sol = DifferentialEquations.solve(dynamics_prob, DifferentialEquations.Rodas5(); 
#                                               abstol=tol, reltol=tol, 
#                                               save_everystep=false,
#                                               maxiters=1000000)
#     u⃗ₜ = dynamics_sol.u[end]
#     Δu⃗ = u⃗ₜ - u⃗₀
#     # Phase condition for starting on y-axis (x=0)
#     phasecondition = u⃗₀[1]  # Assuming first coordinate is x
#     return [Δu⃗; phasecondition]
# end

function create_problem(z⃗₀, p)
    NonlinearSolve.NonlinearProblem(f, z⃗₀, p)
end

function strategy_exponentiate()
    randunitvec() = begin
        θ = 2π*rand()
        r = √(rand())
        r*[cos(θ); sin(θ)]
    end


    tend_limit = 16000
    v₀_limit = 1600
    tend_init = 1.0
    v₀_init = 1.0
    factor = 2
    periodic_sol = Vector{Float64}(undef, 5)
    istrivial_tend_init = true
    istrivial_v₀_init = true
    varsinlimit() = begin
        ((tend_init < tend_limit) && (v₀_init < v₀_limit))
    end
    varstrivial() = begin
        (istrivial_tend_init || istrivial_v₀_init)
    end
    while varsinlimit() && varstrivial()
        # local tend_init, istrivial_tend_init, v₀_init, istrivial_v₀_init, periodic_sol

        u⃗₀_init = [100*randunitvec(); v₀_init * randunitvec()]
        z⃗₀_init = [u⃗₀_init; tend_init]

        root_prob = NonlinearSolve.NonlinearProblem(RootFinding.f, z⃗₀_init, ProblemSetup.p)
        root_sol = NonlinearSolve.solve(root_prob)
        println("Solver status: ", root_sol.retcode)
        println("Residual norm: ", LinearAlgebra.norm(root_sol.resid))
        u⃗₀_sol = root_sol[1:(end-1)]
        tend_sol = root_sol[end]
        v⃗₀_sol = u⃗₀_sol[3:4]
        v₀_sol = LinearAlgebra.norm(v⃗₀_sol)
        println(" ; root:tend_sol ", tend_sol, " ; root:v₀_sol ", v₀_sol)
        lowerlimit = 0.1
        istrivial_tend_init = (tend_sol < lowerlimit)
        istrivial_v₀_init = (v₀_sol < lowerlimit)
        if varstrivial()
            tend_init *= factor
            v₀_init *= factor
        else
            println("Congratulations, found non-trivial periodic orbit")
            periodic_sol = root_sol
        end
        println("something trivial? : ", varstrivial())
    end

    # periodic_sol = 
    # u⃗₀_periodic = periodic_sol[1:4]
    # tend_periodic = periodic_sol[5]
    # # plot the periodic solution
    # plot_solution(ode!, u⃗₀_periodic, tend_periodic, p)
    return periodic_sol
end

function strategy_meshcheck()
    K = 100.0
    N = 10
    meshrange = range(-K, K, N)
    meshtime = range(0.0, K, N)
    count = 0
    roots = []
    println("Hello")
    for x in meshrange
        for y in meshrange
            for vx in meshrange
                for vy in meshrange
                    for t in meshtime
                        global count
                        r = LinearAlgebra.norm([x; y])
                        v = LinearAlgebra.norm([vx; vy])
                        if r < 1.0 || v < 1.0 || t < 1.0
                            println("skipping small cases")
                            continue
                        end
                        z⃗₀_init = [x; y; vx; vy; t]

                        root_prob = NonlinearSolve.NonlinearProblem(
                            RootFinding.f,
                            z⃗₀_init,
                            ProblemSetup.p,
                        )
                        println(z⃗₀_init)
                        root_sol = NonlinearSolve.solve(root_prob)

                        count += 1
                        percentage = 100*count / (N^length(z⃗₀_init))
                        println(percentage, "% completed")

                        if root_sol.retcode == NonlinearSolve.ReturnCode.Success
                            push!(roots, root_sol)
                        end
                    end
                end
            end
        end
    end
    println("Successfuly converged solutions: ", roots)
end

end # moudle RootFinding
