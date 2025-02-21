module ProblemTypes

import FunctionWrappers: FunctionWrapper

export ODE_Function, Time, Tspan, State, Param, Prob

# Type definitions, for readability
ODE_Function = Function
Time = Float64
Tspan = Tuple{Time,Time}
State = Vector{Float64}
struct Param
    r₁
    k₁
    l₁
    r₂
    k₂
    l₂
    m
    g
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

Solver = FunctionWrapper{Solution, Tuple{Prob, StepSize}}
BenchmarkResult = Vector{AbsError}

end # module ProblemTypes
