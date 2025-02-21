module ProblemSetup

export prob

using ..ProblemTypes
using ..Physics

(x₀, y₀) = (0.0, 0.0)
r₀ = [x₀; y₀]
v₀ = [1.0, 0.0]
u₀ = [r₀; v₀]

tspan = (0.0, 20.0)

r₁, k₁, l₁ = [-1.0, -1.0], 1, 1
r₂, k₂, l₂ = [1.0, -2.0], 2, 2
m, g = 1.0, 1.0
p = Param(r₁, k₁, l₁, r₂, k₂, l₂, m, g)

prob = Prob(Physics.two_spring_pendulum, u₀, tspan, p)

end # ProblemSetup
