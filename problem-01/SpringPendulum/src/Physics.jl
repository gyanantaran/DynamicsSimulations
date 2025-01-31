module Physics

using ..Parameters
using LinearAlgebra

export spring_pendulum!;

function spring_pendulum!(du, u, p::Parameters.Param, t)
    r = u[1:2]
    v = u[3:4]

    gravity = p.mass*p.gravity*[0;-1]
    spring = -p.stiffness*(norm(r)-p.restinglen)*(r/norm(r))
    drag = -p.viscosity*v

    du[1:2] = v
    du[3:4] = (1.0/p.mass)*(gravity+spring+drag)
end

end
