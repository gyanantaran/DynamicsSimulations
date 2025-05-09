module Physics

using ..Parameters
using LinearAlgebra
using UnPack

export spring_pendulum3d!

function spring_pendulum3d!(du, u, p::Parameters.Param, t)
    @unpack mass, gravity, stiffness, restinglen#=, viscosity=# = p

    r⃗ = u[1:3]
    v⃗ = u[4:6]

    k = [0.0; 0.0; 1.0]
    gravity = mass * gravity * (-k)
    spring = stiffness * (norm(r⃗) - restinglen) * (-normalize(r⃗))
    # drag = -viscosity * v⃗

    force = (spring #=+ drag =#+ gravity)

    du[1:3] = v⃗
    du[4:6] = force / mass
end

end
