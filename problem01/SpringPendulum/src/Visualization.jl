module Visualization
using GLMakie
using GLMakie.Colors

export plot_trajectory

function plot_trajectory(sol; title = "Spring Pendulum Trajectory")
    a = reduce(hcat, sol.u)'
    x = a[:, 1]
    y = a[:, 2]
    θ = atan.(a[:, 2], a[:, 1])

    xlimits = (minimum(x) - 1, maximum(x) + 1)
    ylimits = (minimum(y) - 1, maximum(y) + 1)

    trajectory_plot = Figure()
    trajectory = Axis(
        trajectory_plot[1, 1],
        title = title,
        xlabel = "X position",
        ylabel = "Y position",
        limits = (xlimits, ylimits),
        aspect = 1,
    )
    lines!(trajectory, x, y, label = "Trajectory")
    axislegend(position = :rb)

    trajectory = Axis(
        trajectory_plot[1, 2],
        title = "Theta vs time",
        xlabel = "Time",
        ylabel = "Theta",
        # limits=,
    )
    lines!(trajectory, sol.t, θ)

    return trajectory_plot
end


function animate(sol; filename = "spring_pendulum.gif", title = "Spring Pendulum Animation")
    sol_matrix = reduce(hcat, sol.u)'
    x = sol_matrix[:, 1]
    y = sol_matrix[:, 2]
    θ = atan.(sol_matrix[:, 2], sol_matrix[:, 1])

    # coarse boundaries, for continuous(interpolated) boundary see: https://docs.sciml.ai/DiffEqDocs/stable/examples/min_and_max/
    xmin = minimum(x)
    xmax = maximum(x)
    ymin = minimum(y)
    ymax = maximum(y)

    animation_plot = plot(
        [x[1]],
        [y[1]],
        aspect_ratio = :equal,
        xlabel = "X position",
        ylabel = "Y position",
        title = title,
        legend = false,
        xlims = (xmin - 1, xmax + 1),
        ylims = (ymin - 1, ymax + 1),
        marker = :circle,
    )

    # Animate by updating plot
    for t in sol.t
        state = sol(t)
        x, y = state[1], state[2]
        plot!(animation_plot, [x], [y])  # Add point to existing plot
        display(animation_plot)
        sleep(0.05)  # Control update rate
    end

end

function makie_animation(sol; filename = "springpendulum_motion.gif", title = "Animation")
    sol_matrix = reduce(hcat, sol.u)'
    x = sol_matrix[:, 1]
    y = sol_matrix[:, 2]
    θ = atan.(sol_matrix[:, 2], sol_matrix[:, 1])

    # coarse boundaries, for continuous(interpolated) boundary see: https://docs.sciml.ai/DiffEqDocs/stable/examples/min_and_max/
    xlimits = (minimum(x) - 1, maximum(x) + 1)
    ylimits = (minimum(y) - 1, maximum(y) + 1)

    time = Observable(0.0)

    x = @lift(sol($time)[1])
    y = @lift(sol($time)[2])

    # Create observables for line coordinates
    line_x = @lift([0, $x])
    line_y = @lift([0, $y])

    animation = Figure()
    ax = Axis(
        animation[1, 1],
        title = @lift("t = $(round($time, digits = 1))"),
        limits = (xlimits, ylimits),
        aspect = 1,
    )

    scatter!(ax, x, y, color = :red, markersize = 15)
    lines!(ax, line_x, line_y, color = :black)

    framerate = 30
    timestamps = range(0, last(sol.t), step = 1 / framerate)

    record(animation, filename, timestamps; framerate = framerate) do t
        time[] = t
    end

    return animation
end


end
