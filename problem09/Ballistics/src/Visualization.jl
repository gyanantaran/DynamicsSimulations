module Visualization

import GLMakie

export plot_trajectory

function plot_trajectory(
    sol_state;
    title = "Ballistics Motion",
    filename = "numerical_trajectory.png",
)
    sol = reduce(hcat, sol_state)'

    x = view(sol, :, 1)
    y = view(sol, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], xlabel = "x", ylabel = "y", title = title)
    numeric_plot = GLMakie.lines!(ax, x, y)
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_trajectory(
    sol_numeric,
    sol_analytic,
    filename = "numeric_and_analytical_trajectories.png",
)
    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    x_numeric = view(sol_numeric_matrix, :, 1)
    y_numeric = view(sol_numeric_matrix, :, 2)

    x_analytic = 0.000 .+ view(sol_analytic_matrix, :, 1)
    y_analytic = view(sol_analytic_matrix, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], xlabel = "x", ylabel = "y")
    numeric_plot = GLMakie.lines!(ax, x_numeric, y_numeric)
    analytic_plot = GLMakie.lines!(ax, x_analytic, y_analytic)
    GLMakie.Legend(fig[1, 2], [numeric_plot, analytic_plot], ["Numeric", "Analytic"])
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_position(
    sol_numeric,
    sol_analytic,
    filename = "numeric_and_analytical_trajectories.png",
)
    t = sol_numeric.t

    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    x_numeric = view(sol_numeric_matrix, :, 1)
    y_numeric = view(sol_numeric_matrix, :, 2)

    x_analytic = view(sol_analytic_matrix, :, 1)
    y_analytic = view(sol_analytic_matrix, :, 2)

    # plotting
    fig = GLMakie.Figure()
    ax_vx = GLMakie.Axis(fig[1, 1], xlabel = "t", ylabel = "x")
    ax_vy = GLMakie.Axis(fig[1, 2], xlabel = "t", ylabel = "y")

    x_numeric_plot = GLMakie.lines!(ax_vx, t, x_numeric)
    x_analytic_plot = GLMakie.lines!(ax_vx, t, x_analytic)

    y_numeric_plot = GLMakie.lines!(ax_vy, t, y_numeric)
    y_analytic_plot = GLMakie.lines!(ax_vy, t, y_analytic)

    GLMakie.Legend(
        fig[1, 3],
        [[x_numeric_plot, y_numeric_plot], [x_analytic_plot, y_analytic_plot]],
        ["Numeric", "Analytic"],
    )
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_both_velocity(
    sol_numeric,
    sol_analytic,
    filename = "numeric_and_analytical_trajectories.png",
)
    t = sol_numeric.t

    sol_numeric_matrix = reduce(hcat, sol_numeric)'
    sol_analytic_matrix = reduce(hcat, sol_analytic)'

    vx_numeric = view(sol_numeric_matrix, :, 3)
    vy_numeric = view(sol_numeric_matrix, :, 4)

    vx_analytic = view(sol_analytic_matrix, :, 3)
    vy_analytic = view(sol_analytic_matrix, :, 4)

    # plotting
    fig = GLMakie.Figure()
    ax_vx = GLMakie.Axis(fig[1, 1], xlabel = "t", ylabel = "vx")
    ax_vy = GLMakie.Axis(fig[1, 2], xlabel = "t", ylabel = "vy")

    vx_numeric_plot = GLMakie.lines!(ax_vx, t, vx_numeric)
    vx_analytic_plot = GLMakie.lines!(ax_vx, t, vx_analytic)

    vy_numeric_plot = GLMakie.lines!(ax_vy, t, vy_numeric)
    vy_analytic_plot = GLMakie.lines!(ax_vy, t, vy_analytic)

    GLMakie.Legend(
        fig[1, 3],
        [[vx_numeric_plot, vy_numeric_plot], [vx_analytic_plot, vy_analytic_plot]],
        ["Numeric", "Analytic"],
    )
    GLMakie.save(filename, fig)
    GLMakie.display(fig)
end

function plot_abs_steps_vs_error(log_steps, log_errors)
    log_errors_midpoint, log_errors_rk4 = log_errors["midpoint"], log_errors["rk4"]

    fig = GLMakie.Figure()
    ax = GLMakie.Axis(
        fig[1, 1],
        aspect = GLMakie.DataAspect(),
        xticks = log_steps,
        title = "Steps vs Error (Midpoint and RK4 methods)",
        xlabel = GLMakie.L"\log_{10}(\text{steps})",
        ylabel = GLMakie.L"\log_{10}(\text{errors})",
    )

    midpoint_plot = GLMakie.lines!(log_steps, log_errors_midpoint)
    GLMakie.scatter!(log_steps, log_errors_midpoint)

    rk4_plot = GLMakie.lines!(log_steps, log_errors_rk4)
    GLMakie.scatter!(log_steps, log_errors_rk4)

    GLMakie.Legend(fig[1, 2], [midpoint_plot, rk4_plot], ["Midpoint", "RK4"])

    GLMakie.save("steps_vs_error_two_methods_compare.png", fig)
    GLMakie.display(fig)
end

function plot_abs_steps_vs_time(time_histories, error_histories)
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(
        fig[1, 1],
        title = "Time vs Running Error",
        xlabel = "time",
        ylabel = GLMakie.L"\log_{10}(\text{manhatten error})",
        aspect = 0.75,
    )
    histories = zip(time_histories, error_histories)

    GLMakie.xlims!(ax, (-0.25, 1.25))
    GLMakie.ylims!(ax, (-20.0, 0.0))
    for history in histories
        GLMakie.lines!(history...)
    end

    GLMakie.save("time_vs_running_error.png", fig)
    GLMakie.display(fig)
end

function plot_tolerances_vs_error(xs, ys, zs)
    fig = GLMakie.Figure(resolution = (1200, 600), fontsize = 14)
    log_xs = log10.(xs)
    log_ys = log10.(ys)
    log_zs = log10.(zs)
    ax1 = GLMakie.Axis3(
        fig[1, 1];
        aspect = (1, 1, 1),
        xlabel = GLMakie.L"log_{10}(\text{abstol})",
        ylabel = GLMakie.L"log_{10}(\text{reltol})",
        zlabel = GLMakie.L"log_{10}(\text{error})",
        title = "3D Error Surface",
    )
    ax2 = GLMakie.Axis(
        fig[1, 2];
        aspect = 1,
        xlabel = GLMakie.L"log_{10}(\text{abstol})",
        ylabel = GLMakie.L"log_{10}(\text{reltol})",
        title = "Error Heatmap",
    )
    colormap = :viridis
    surf = GLMakie.surface!(ax1, log_xs, log_ys, log_zs; colormap = colormap)
    hm = GLMakie.heatmap!(ax2, log_xs, log_ys, log_zs; colormap = colormap)
    GLMakie.contour!(
        ax2,
        log_xs,
        log_ys,
        log_zs;
        levels = 10,
        color = :black,
        linewidth = 0.5,
    )
    cbar = GLMakie.Colorbar(fig[1, 3], hm; label = GLMakie.L"log_{10}(\text{error})")
    GLMakie.Label(
        fig[0, :],
        "Midpoint Method, Tiny Tolerance vs. Error Analysis",
        fontsize = 20,
    )
    min_idx = argmin(log_zs)
    GLMakie.scatter!(
        ax2,
        [log_xs[min_idx]],
        [log_ys[min_idx]],
        color = :red,
        markersize = 15,
    )
    GLMakie.save("tolerances_vs_error_combined.png", fig; px_per_unit = 2)
    GLMakie.display(fig)
end

end # module Visualization
