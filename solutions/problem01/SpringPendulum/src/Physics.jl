module Physics

using ..Parameters
using LinearAlgebra
using UnPack

export spring_pendulum!

function spring_pendulum!(du, u, p::Parameters.Param, t)
    @unpack mass, gravity, stiffness, restinglen, viscosity = p

    r⃗ = u[1:2]
    v⃗ = u[3:4]

    ĵ = [0.0; 1.0]
    gravity = mass * gravity * (-ĵ)
    spring = stiffness * (norm(r⃗) - restinglen) * (-normalize(r⃗))
    drag = -viscosity * v⃗

    force = (spring + drag + gravity)

    du[1:2] = v⃗
    du[3:4] = force / mass
end

end
