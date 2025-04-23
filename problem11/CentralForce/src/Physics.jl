module Physics

import LinearAlgebra

function inversecube(r⃗, p)
    r = LinearAlgebra.norm(r⃗)
    F = (r ^ 2.0)
end

function speedindependentofradius(r⃗, p)
    r = LinearAlgebra.norm(r⃗)
    F = (p.k * p.m / r)
    return F
end

function dipolepowerlaw(r⃗, p)
    p₁ = [+1.0, 0.0]
    p₂ = [0.0, +1.0]
    p₃ = [-1.0, 0.0]
    p₄ = [0.0, -1.0]

    r₁ = LinearAlgebra.norm((r⃗ - p₁))
    r₂ = LinearAlgebra.norm((r⃗ - p₂))
    r₃ = LinearAlgebra.norm((r⃗ - p₃))
    r₄ = LinearAlgebra.norm((r⃗ - p₄))

    k = -2
    F = (r₁)^(k) - (r₂)^(k) + (r₃)^(k) - (r₄)^(k)

    return F
end

function create_ode(F::Function)
    return function centralforce!(du, u, p, t)
        r⃗ = u[1:2]
        v⃗ = u[3:4]

        r̂ = LinearAlgebra.normalize(r⃗)
        F⃗ = F(r⃗, p) * (-r̂)
        a⃗ = F⃗ / p.m

        du[1:2] = v⃗
        du[3:4] = a⃗
    end
end

end # module Physics
