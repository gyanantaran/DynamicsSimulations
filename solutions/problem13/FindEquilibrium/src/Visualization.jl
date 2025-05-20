module Visualization

import GLMakie

function plot_trajectory!(figure, sol)
    sol = reduce(hcat, sol.u)'
    xs = view(sol, :, 1)
    ys = view(sol, :, 2)
    GLMakie.lines!(figure[1,1], xs, ys)
end

function plot_start_end!(figure, sol)
    sol = reduce(hcat, sol.u)'
    xs = sol[[1,end], 1]
    ys = sol[[1,end], 2]
    GLMakie.lines!(figure[1,1], xs, ys)
end

function plot_end!(figure, sol)
    sol = reduce(hcat, sol.u)'
    xs = sol[end, 1]
    ys = sol[end, 2]
    GLMakie.scatter!(figure[1,1], [xs], [ys])
end

function plot_points!(figure, r⃗₁, r⃗₂)
    two_points = figure[1,1]
    GLMakie.scatter!(two_points, [r⃗₁[1]], [r⃗₁[2]])
    GLMakie.scatter!(two_points, [r⃗₂[1]], [r⃗₂[2]])
end

end # module Visualization