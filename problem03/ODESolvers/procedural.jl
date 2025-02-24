#!/usr/bin/env julia

import GLMakie  # for plotting
import LinearAlgebra  # for norm

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
Solution = Vector{State}

# Physics/ODEs describing the system
function two_spring_pendulum(u::State, p::Param, t::Time)
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
    spring1 = k₁ * (LinearAlgebra.norm(seperation1) - l₁) * -LinearAlgebra.normalize(seperation1)
    seperation2 = (r - r₂)
    spring2 = k₂ * (LinearAlgebra.norm(seperation2) - l₂) * -LinearAlgebra.normalize(seperation2)
    gravity = m * g * -j

    F = (1 / m) * (spring1 + spring2 + gravity)

    u_new = [0.0; 0; 0; 0]
    u_new[1:2] = v
    u_new[3:4] = F / m

    return u_new
end


# Plotting function
function plot_trajectory_makie(sol::Solution, prob::Prob)::GLMakie.Figure
    # Convert solution to matrix form
    sol_matrix = reduce(hcat, sol)'

    # Create figure
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], aspect=GLMakie.DataAspect())

    # Plot trajectory
    GLMakie.lines!(ax, sol_matrix[:, 1], sol_matrix[:, 2])

    # Plot reference points
    r₁, r₂ = prob.p.r₁, prob.p.r₂
    GLMakie.scatter!(ax, [r₁[1]], [r₁[2]], color=:red, markersize=15)
    GLMakie.scatter!(ax, [r₂[1]], [r₂[2]], color=:blue, markersize=15)

    # Display the figure
    return fig
end

# Problem Setup
(x₀, y₀) = (0.0, 0.0)
r₀ = [x₀; y₀]
v₀ = [1.0, 0.0]
u₀ = [r₀; v₀]

tspan = (0.0, 100.0)

r₁, k₁, l₁ = [-1.0, -1.0], 1, 1
r₂, k₂, l₂ = [1.0, -1.0], 1, 1
m, g = 1.0, 0.0
p = Param(r₁, k₁, l₁, r₂, k₂, l₂, m, g)

prob = Prob(two_spring_pendulum, u₀, tspan, p)

function euler_solve(prob::Prob)::Solution
    # unpack variables
    my_ode = prob.ode
    u₀ = prob.u₀
    tstart, tend = prob.tspan
    p = prob.p

    sol::Vector{State} = [u₀]

    # eulers method
    Δh = 0.001
    tspan = tstart:Δh:tend
    uₜ = u₀
    for t in tspan
        dₜu = my_ode(uₜ, p, t)
        uₜ = uₜ + Δh * dₜu
        push!(sol, uₜ)
    end
    return sol
end
sol = euler_solve(prob)

trajectory_plot = plot_trajectory_makie(sol, prob)

GLMakie.save("two_spring_pendulum.png", trajectory_plot)

GLMakie.display(trajectory_plot)
