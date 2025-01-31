module Parameters
export Param
struct Param
    mass::Float64
    gravity::Float64
    viscosity::Float64
end

Param(;m=1.0, g=10.0, c=1.0) = Param(m, g, c)

end
