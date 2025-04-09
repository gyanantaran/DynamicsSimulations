module Physics

import LinearAlgebra

function speedindependentofradius(r⃗, p)
    r = LinearAlgebra.norm(r⃗)
    F = (p.k * p.m / r)
    return F
end

function dipolepowerlaw(r⃗, p)
    r₁ = LinearAlgebra.norm(r⃗ - [+1.0, 0.0])
    r₂ = LinearAlgebra.norm(r⃗ - [-1.0, 0.0])
    F = (p.m / r₁)  + (p.m / r₂)
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
