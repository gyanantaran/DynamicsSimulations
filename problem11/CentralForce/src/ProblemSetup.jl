module ProblemSetup

import ..Physics
import DifferentialEquations

function create_problem(ode, u⃗₀, tend, p)
    tstart = 0.0
    tspan = (tstart, tend)

    DifferentialEquations.ODEProblem(ode, u⃗₀, tspan, p)
end

end # module ProblemSetup
