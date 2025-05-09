module Physics

using ..Parameters

export ballistic!

function ballistic!(du, u, p::Parameters.Param, t)
    du[1:2] = u[3:4]
    du[3:4] = -p.mass * p.gravity * [0; 1] + -p.viscosity * u[3:4]
end


end
