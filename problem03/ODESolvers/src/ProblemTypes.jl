module ProblemTypes

import FunctionWrappers: FunctionWrapper

export ODE_Function, Time, Tspan, State, Param, Prob

# Type definitions, for readability
ODE_Function = Function
Time = Float64
Tspan = Tuple{Time,Time}
State = Vector{Float64}
struct Param
    r₁::Any
    k₁::Any
    l₁::Any
    r₂::Any
    k₂::Any
    l₂::Any
    m::Any
    g::Any
end
struct Prob
    ode::ODE_Function
    u₀::State
    tspan::Tspan
    p::Param
end
StepSize = Float64
StepSizes = Vector{StepSize}

Solution = Vector{State}
AbsError = Float64

Solver = FunctionWrapper{Solution,Tuple{Prob,StepSize}}
BenchmarkResult = Vector{AbsError}

end # module ProblemTypes
