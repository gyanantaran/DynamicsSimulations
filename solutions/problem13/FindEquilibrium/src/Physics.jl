module Physics

import LinearAlgebra: norm, normalize, dot

function twospringsdragdamped!(du, u, p, t)
    m, g, c_d, spring1, spring2 = p.m, p.g, p.c_d, p.spring1, p.spring2

    r⃗ = u[1:2]
    v⃗ = u[3:4]
    a⃗ = begin
        gravity = begin
            j = [0.0;1.0]
            m*g*(-j)
        end
        drag = begin
            v = norm(v⃗)
            v̂ = v⃗/v
            (c_d*v)*(-v̂)
        end
        spring1 = begin
            spring = begin
                Δr⃗ = r⃗ - spring1.r⃗₀
                Δr = norm(Δr⃗)
                Δl = Δr - spring1.l
                Δr̂ = Δr⃗ / Δr
                (spring1.k*Δl)*(-Δr̂)
            end
            dashpot = begin
                r̂ = normalize(r⃗)
                (spring1.c*dot(v⃗, r̂))*(-r̂)
            end
            spring+dashpot
        end
        spring2 = begin
            spring = begin
                Δr⃗ = r⃗ - spring2.r⃗₀
                Δr = norm(Δr⃗)
                Δl = Δr - spring2.l
                Δr̂ = Δr⃗ / Δr
                (spring2.k*Δl)*(-Δr̂)
            end
            dashpot = begin
                r̂ = normalize(r⃗)
                (spring2.c*dot(v⃗, r̂))*(-r̂)
            end
            spring+dashpot
        end
        F = +gravity+drag+spring1+spring2
        F/m
    end

    du[1:2] = v⃗
    du[3:4] = a⃗
end

end # module Physics