module EulersMethod

# problem setup
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

function my_ode(u, p, t)
    r = u[1:2]
    v = u[3:4]

    r₁ = p.r₁
    k₁ = p.k₁
    r₂ = p.r₂
    k₂ = p.k₂

    m = p.m
    g = p.g

    j = [0; 1]

    spring1 = -k₁ * (r - r₁)
    spring2 = -k₂ * (r - r₂)
    gravity = -m * g * j

    F = (1 / m) * (spring1 + spring2 + gravity)

    u_new = [0.0; 0; 0; 0]
    u_new[1:2] = v
    u_new[3:4] = F / m

    return u_new
end

(x₀, y₀) = (0.0, 0.0)
r₀ = [x₀; y₀]
v₀ = [0.0, 0.0]
u₀ = [r₀; v₀]

r₁, k₁, l₁ = [-1.0, -1.0], 1, 1
r₂, k₂, l₂ = [-1.0, -1.0], 1, 1
m, g = 1.0, 1.0
p = Param(r₁, k₁, l₁, r₂, k₂, l₂, m, g)

u = u₀
tstart, tend = 0.0, 10.0

# eulers method
Δh = 0.00001
tspan = tstart:Δh:tend
uₜ = u₀
for t in tspan
    dₜu = my_ode(uₜ, p, t)
    global uₜ = uₜ + Δh * dₜu
end
print(uₜ)

# for i in en
#     my_ode!(dₜu, u, p, t)
#     u += Δh * dₜu
# end

# Physics: definition of my ODE
function my_ode!(du, u, p, t)
    r = u[1:2]
    v = u[3:4]

    r₁ = p.r₁
    k₁ = p.k₁
    r₂ = p.r₂
    k₂ = p.k₂

    m = p.m
    g = p.g

    j = [0; 1]

    spring1 = -k₁ * (r - r₁)
    spring2 = -k₂ * (r - r₂)
    gravity = -m * g * j

    F = (1 / m) * (spring1 + spring2 + gravity)

    du[1:2] = v
    du[3:4] = F / m
end


end # module EulersMethod
