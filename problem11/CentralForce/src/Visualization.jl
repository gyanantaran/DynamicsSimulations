module Visualization

import GLMakie

function plot_trajectory(sol)
    sol = reduce(hcat, sol.u)'
    r = view(sol, :, 1:2)
    # v = view(sol, :, 3:4)

    trajectory = GLMakie.Figure()
    ax = GLMakie.Axis(
        trajectory[1, 1],
        title = "Trajectory Central Force",
        aspect = GLMakie.DataAspect(),
    )

    x = view(r, :, 1)
    y = view(r, :, 2)
    GLMakie.lines!(ax, x, y)

    # p₁ = [1.0, 0.0]
    # p₂ = [0.0, +1.0]
    # p₃ = [-1.0, 0.0]
    # p₄ = [0.0, -1.0]

    # GLMakie.scatter!(ax, p₁[1], p₁[2])
    # GLMakie.scatter!(ax, p₂[1], p₂[2])
    # GLMakie.scatter!(ax, p₃[1], p₃[2])
    # GLMakie.scatter!(ax, p₄[1], p₄[2])

    # GLMakie.xlims!(ax, [-4, +4])
    # GLMakie.ylims!(ax, [-4, +4])
    return trajectory
end

end # module Visualization
