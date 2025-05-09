module Physics

function F(r⃗, p)
    # dipolepowerlaw(r⃗, p)
    speedindependentofradius(r⃗, p)
    # inversepowerlaw(r⃗, p)
    # hillinvalley(r⃗, p)
end

function hillinvalley(r⃗, p)
    r = norm(r⃗)
    σ = 5
    a = 5
    e = a*exp(-σ*r^2)
    p = r^2
    F = e+p #-a
end

function inversepower(r, k)
    return r^k
end

function inversepowerlaw(r⃗, p)
    r = norm(r⃗)
    F = inversepower(r, p.k)
end

function speedindependentofradius(r⃗, p)
    r = norm(r⃗)
    F = (p.k * p.m / r)
    return F
end

function dipolepowerlaw(r⃗, p)
    p₁ = [1.0, 0.0]
    p₂ = [0.0, +1.0]
    p₃ = [-1.0, 0.0]
    p₄ = [0.0, -1.0]
    points = [p₁, p₂, p₃, p₄]
    norms = norm.((r⃗ .- points))
    k = -2
    F = sum(inversepower.(norms, Ref{k}))
    return F
end

function norm(r⃗)
    x, y = r⃗
    r = x^2+y^2
    ϵ = 1e-5
    max(r, ϵ)
end

function normalize(r⃗)
    r = norm(r⃗)
    r⃗ / r
end

function centralforce!(du, u, p, t)
    r⃗ = u[1:2]
    v⃗ = u[3:4]
    r̂ = normalize(r⃗)
    F⃗ = F(r⃗, p) * (-r̂)
    a⃗ = F⃗ / p.m
    du[1:2] = v⃗
    du[3:4] = a⃗
end

end # module Physics
