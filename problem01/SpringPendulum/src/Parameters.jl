module Parameters
export Param
struct Param
    mass::Float64
    gravity::Float64
    viscosity::Float64
    stiffness::Float64
    restinglen::Float64
end

Param(; m = 1.0, g = 10.0, c = 1.0, k = 1.0, l₀ = 1.0) = Param(m, g, c, k, l₀)

end
