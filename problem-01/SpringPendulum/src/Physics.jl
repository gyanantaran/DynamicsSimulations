module Physics

using ..Parameters
using LinearAlgebra
using UnPack

export spring_pendulum!;

function spring_pendulum!(du, u, p::Parameters.Param, t)
    @unpack mass, gravity, stiffness, restinglen, viscosity = p

    r = u[1:2]
    v = u[3:4]

    gravity = mass*gravity*[0;-1]
    spring = -stiffness*(norm(r)-restinglen)*(r/norm(r))
    drag = -viscosity*v

    du[1:2] = v
    du[3:4] = (1.0/mass)*(gravity+spring+drag)
end

end
