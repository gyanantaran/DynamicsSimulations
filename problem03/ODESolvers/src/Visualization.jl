module Visualization

export plot_trajectory

import Plots
import GLMakie

using ..ProblemTypes

function plot_trajectory(sol::ProblemTypes.Solution, prob::ProblemTypes.Prob)::Nothing
    sol_matrix = reduce(hcat, sol)'
    trajectory = Plots.plot(sol_matrix[:, 1], sol_matrix[:, 2], aspect_ratio = :equal)
    r₁, r₂ = prob.p.r₁, prob.p.r₂
    Plots.scatter!(trajectory, [r₁[1]], [r₁[2]])
    Plots.scatter!(trajectory, [r₂[1]], [r₂[2]])
    Plots.display(trajectory)
    return nothing
end

function plot_trajectory_makie(sol::ProblemTypes.Solution, prob::ProblemTypes.Prob)::Nothing
    # Convert solution to matrix form
    sol_matrix = reduce(hcat, sol)'

    # Create figure
    fig = GLMakie.Figure()
    ax = GLMakie.Axis(fig[1, 1], aspect = GLMakie.DataAspect())

    # Plot trajectory
    GLMakie.lines!(ax, sol_matrix[:, 1], sol_matrix[:, 2])

    # Plot reference points
    r₁, r₂ = prob.p.r₁, prob.p.r₂
    GLMakie.scatter!(ax, [r₁[1]], [r₁[2]], color = :red, markersize = 15)
    GLMakie.scatter!(ax, [r₂[1]], [r₂[2]], color = :blue, markersize = 15)

    # Display the figure
    GLMakie.display(fig)
    return nothing
end

function makie_animation(sol; filename = "two_spring_pendulum.gif", title = "Animation")
    sol_matrix = reduce(hcat, sol.u)'
    x = sol_matrix[:, 1]
    y = sol_matrix[:, 2]
    θ = atan.(sol_matrix[:, 2], sol_matrix[:, 1])

    # coarse boundaries, for continuous(interpolated) boundary see: https://docs.sciml.ai/DiffEqDocs/stable/examples/min_and_max/
    xlimits = (minimum(x) - 1, maximum(x) + 1)
    ylimits = (minimum(y) - 1, maximum(y) + 1)

    time = GLMakie.Observable(0.0)

    x = GLMakie.@lift(sol($time)[1])
    y = GLMakie.@lift(sol($time)[2])

    # Create observables for line coordinates
    line_x = GLMakie.@lift([0, $x])
    line_y = GLMakie.@lift([0, $y])

    animation = GLMakie.Figure()
    ax = GLMakie.Axis(
        animation[1, 1],
        title = GLMakie.@lift("t = $(round($time, digits = 1))"),
        limits = (xlimits, ylimits),
        aspect = 1,
    )

    GLMakie.scatter!(ax, x, y, color = :red, markersize = 15)
    GLMakie.lines!(ax, line_x, line_y, color = :black)

    framerate = 30
    timestamps = range(0, last(sol.t), step = 1 / framerate)

    GLMakie.record(animation, filename, timestamps; framerate = framerate) do t
        time[] = t
    end

    return animation
end


function plot_benchmark_result(
    step_sizes::ProblemTypes.StepSizes,
    abs_errors::ProblemTypes.BenchmarkResult;
    filename = "benchmark_result.png",
)
    # Convert solution to matrix form
    step_sizes = step_sizes[2:end]

    # Create figure
    benchmark_plot = GLMakie.Figure()
    ax = GLMakie.Axis(
        benchmark_plot[1, 1],
        xlabel = "log(step_sizes)",
        ylabel = "log(abs_errors)",
        aspect = 1,
    )

    GLMakie.lines!(ax, log.(step_sizes), log.(abs_errors))

    #     # Compute arrow positions and directions
    #     arrow_starts = [GLMakie.Point2f(log_step_sizes[i], log_abs_errors[i]) for i in 1:length(log_step_sizes)-1]
    #     arrow_dirs = [GLMakie.Point2f(log_step_sizes[i+1] - log_step_sizes[i], log_abs_errors[i+1] - log_abs_errors[i]) for i in 1:length(log_step_sizes)-1]
    #     # Plot arrows at each point
    #     GLMakie.arrows!(ax, arrow_starts, arrow_dirs, arrowsize=10, linewidth=2, color=:red)

    # Display the figure
    GLMakie.save(filename, benchmark_plot)
    GLMakie.display(benchmark_plot)
    return nothing
end

end # module Visualization
