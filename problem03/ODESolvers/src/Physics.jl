module Physics

using LinearAlgebra

using ..ProblemTypes

function two_spring_pendulum(u::ProblemTypes.State, p::ProblemTypes.Param, t::ProblemTypes.Time)
    r = u[1:2]
    v = u[3:4]

    r₁ = p.r₁
    k₁ = p.k₁
    l₁ = p.l₁
    r₂ = p.r₂
    k₂ = p.k₂
    l₂ = p.l₂

    m = p.m
    g = p.g

    j = [0; 1]

    seperation1 = (r - r₁)
    spring1 = k₁ * (norm(seperation1) - l₁) * -normalize(seperation1)

    seperation2 = (r - r₂)
    spring2 = k₂ * (norm(seperation2) - l₂) * -normalize(seperation2)
    gravity = m * g * -j

    F = (spring1 + spring2 + gravity)
    a = F / m

    u_new = [0.0; 0; 0; 0]
    u_new[1:2] = v
    u_new[3:4] = a

    return u_new
end

function two_spring_pendulum!(du::ProblemTypes.State, u::ProblemTypes.State, p::Param, t::ProblemTypes.Tspan)
    r = u[1:2]
    v = u[3:4]

    r₁ = p.r₁
    k₁ = p.k₁
    l₁ = p.l₁
    r₂ = p.r₂
    k₂ = p.k₂
    l₂ = p.l₂

    m = p.m
    g = p.g

    j = [0; 1]

    seperation1 = (r - r₁)
    spring1 = k₁ * (norm(seperation1) - l₁) * -normalize(seperation1)
    seperation2 = (r - r₂)
    spring2 = k₂ * (norm(seperation2) - l₂) * -normalize(seperation2)
    gravity = m * g * -j

    F = (spring1 + spring2 + gravity)
    a = F / m

    du[1:2] = v
    du[3:4] = a
end


end # Physics
