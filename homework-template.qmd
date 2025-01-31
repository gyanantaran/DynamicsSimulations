---
title: "Homework1"
author: "Vishal Paudel"
date: "2025/01/24"
format:
  html:
    code-fold: true
  docx:
    fig-align: center
jupyter: julia-1.11
---

### Trajectory

Plot function pair (t, u(t)). 
See @fig-trajectory for an example.

```{julia}
#| eval: false
{{< include ../SpringPendulum/src/SpringPendulum.jl >}}
```

```{julia}
#| label: fig-trajectory
#| fig-cap: "Parametric Plots"
#| echo: false
#| warning: false
include("../SpringPendulum/src/SpringPendulum.jl");
```

### Animation

```julia
function makie_animation(sol; filename="sol_animation.gif", title="Animation")
    sol_matrix = reduce(hcat, sol.u)'
    x =  sol_matrix[:, 1]
    y = sol_matrix[:, 2]
    θ = atan.(sol_matrix[:, 2], sol_matrix[:, 1])

    # coarse boundaries, for continuous(interpolated) boundary see: https://docs.sciml.ai/DiffEqDocs/stable/examples/min_and_max/
    xlimits = (minimum(x)-1, maximum(x)+1)
    ylimits = (minimum(y)-1, maximum(y)+1)

    time = Observable(0.0)

    x = @lift(sol($time)[1])
    y = @lift(sol($time)[2])

    # Create observables for line coordinates
    line_x = @lift([0, $x])
    line_y = @lift([0, $y])

    fig = Figure()
    ax = Axis(fig[1, 1], title = @lift("t = $(round($time, digits = 1))"), limits=(xlimits, ylimits), aspect=1)

    scatter!(ax, x, y, color=:red, markersize = 15)
    lines!(ax, line_x, line_y, color=:black)

    framerate = 30
    timestamps = range(0, last(sol.t), step=1/framerate)

    record(fig, filename, timestamps;
            framerate = framerate) do t
        time[] = t
    end
end
```

![Animation](../SpringPendulum/sol_animation.gif)
