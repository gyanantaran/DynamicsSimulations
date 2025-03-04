module Visualization

import GLMakie

export plot_trajectory

function plot_trajectory(sol_state; title="Ballistics Motion", filename="numerical_trajectory.png")
    sol = reduce(hcat, sol_state)'

    x = view(sol, :, 1)
    y = view(sol, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], xlabel="x", ylabel="y", title=title)
    numeric_plot = GLMakie.lines!(ax, x, y)
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_trajectory(sol_numeric, sol_analytic, filename="numeric_and_analytical_trajectories.png")
    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    x_numeric = view(sol_numeric_matrix, :, 1)
    y_numeric = view(sol_numeric_matrix, :, 2)

    x_analytic = 0.000 .+ view(sol_analytic_matrix, :, 1)
    y_analytic = view(sol_analytic_matrix, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], xlabel="x", ylabel="y")
    numeric_plot = GLMakie.lines!(ax, x_numeric, y_numeric)
    analytic_plot = GLMakie.lines!(ax, x_analytic, y_analytic)
    GLMakie.Legend(fig[1,2], [numeric_plot, analytic_plot], ["Numeric", "Analytic"])
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_position(sol_numeric, sol_analytic, filename="numeric_and_analytical_trajectories.png")
    t = sol_numeric.t

    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    x_numeric = view(sol_numeric_matrix, :, 1)
    y_numeric = view(sol_numeric_matrix, :, 2)

    x_analytic = view(sol_analytic_matrix, :, 1)
    y_analytic = view(sol_analytic_matrix, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax_vx = GLMakie.Axis(fig[1, 1], xlabel="t", ylabel="x", )
    ax_vy = GLMakie.Axis(fig[1, 2], xlabel="t", ylabel="y", )

    x_numeric_plot = GLMakie.lines!(ax_vx, t, x_numeric)
    x_analytic_plot = GLMakie.lines!(ax_vx, t, x_analytic)

    y_numeric_plot = GLMakie.lines!(ax_vy, t, y_numeric)
    y_analytic_plot = GLMakie.lines!(ax_vy, t, y_analytic)

    GLMakie.Legend(fig[1,3], [[x_numeric_plot, y_numeric_plot], [x_analytic_plot, y_analytic_plot]], ["Numeric", "Analytic"])
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_velocity(sol_numeric, sol_analytic, filename="numeric_and_analytical_trajectories.png")
    t = sol_numeric.t

    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    vx_numeric = view(sol_numeric_matrix, :, 3)
    vy_numeric = view(sol_numeric_matrix, :, 4)

    vx_analytic = view(sol_analytic_matrix, :, 3)
    vy_analytic = view(sol_analytic_matrix, :, 4)

    # plotting
    fig = GLMakie.Figure()
    ax_vx = GLMakie.Axis(fig[1, 1], xlabel="t", ylabel="vx", )
    ax_vy = GLMakie.Axis(fig[1, 2], xlabel="t", ylabel="vy", )

    vx_numeric_plot = GLMakie.lines!(ax_vx, t, vx_numeric)
    vx_analytic_plot = GLMakie.lines!(ax_vx, t, vx_analytic)

    vy_numeric_plot = GLMakie.lines!(ax_vy, t, vy_numeric)
    vy_analytic_plot = GLMakie.lines!(ax_vy, t, vy_analytic)

    GLMakie.Legend(fig[1,3], [[vx_numeric_plot, vy_numeric_plot], [vx_analytic_plot, vy_analytic_plot]], ["Numeric", "Analytic"])
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

end # module Visualization
