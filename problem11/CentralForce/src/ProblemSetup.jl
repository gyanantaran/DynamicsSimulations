module ProblemSetup

import ..Physics
import DifferentialEquations

struct Param
    m::Float64
    k::Float64
end

# u⃗₀ = [1.0; 1.0; 0.0; 1.0]
# tend = 50.0
m = 1.0
k = 1.0
p = Param(m, k)

ode! = Physics.centralforce!

function create_problem(ode, u⃗₀, tend, p)
    tstart = 0.0
    tspan = (tstart, tend)

    DifferentialEquations.ODEProblem(ode, u⃗₀, tspan, p)
end

end # module ProblemSetup
