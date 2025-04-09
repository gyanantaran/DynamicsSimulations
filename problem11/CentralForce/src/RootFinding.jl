module RootFinding

import NonlinearSolve
import DifferentialEquations

import ..ProblemSetup

function f((; z⃗₀, t), p)
    # z initial state; t period;
    # create problem
    # solve problem
    # return what needs to 

    prob = ProblemSetup.Problem(z⃗₀, t, p)

    z⃗ₜ = DifferentialEquations.solve(prob)
    Δz⃗ = z⃗ₜ - z⃗₀

    Δz⃗
end

root_finding_prob = NonlinearSolve.NonlinearProblem(f, u₀, p)

end # moudle RootFinding
