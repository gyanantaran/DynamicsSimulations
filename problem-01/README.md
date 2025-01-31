---
title: "problem-01: Spring Pendulum Analysis"
author: "Vishal Paudel"
date: "2025/01/24"
format:
  docx:
    fig-align: center
---

> 1. Set up (define system, draw FBD, write ODEs) a particle problem. Just one particle.
2D or 3D, your choice. Use a force, or forces that you like (gravity, spring, air friction).
Any example of interest. Find a numerical solution. Graph it. Animate it. Try to
make an interesting observation.

### System Description and Free Body Diagram
I think I have chosen a just hard enough interesting problem. A spring pendulum consists of a mass $m$ attached to a spring of natural length $l_0$ and spring constant $k$. The system experiences:  
- Spring force $F_s = -k(l-l_0)\hat{r}$  
- Gravitational force $F_g = -mg\hat{j}$  
- Damping force $F_d = -c\vec{v}$  

![Freebody-diagram](freebody-diagram.png)

### Equations of Motion
In Cartesian coordinates $(x,y)$, Newton's second law gives:

$m\ddot{x} = -k(l-l_0)\frac{x}{l} - c\dot{x}$

$m\ddot{y} = -k(l-l_0)\frac{y}{l} - c\dot{y} - mg$

where $l = \sqrt{x^2 + y^2}$ is the instantaneous length.

The corresponding code for the ODE:
```julia
function spring_pendulum!(du, u, p::Parameters.Param, t)
    r = u[1:2]
    v = u[3:4]

    gravity = p.mass*p.gravity*[0;-1]
    spring = -p.stiffness*(norm(r)-p.restinglen)*(r/norm(r))
    drag = -p.viscosity*v

    du[1:2] = v
    du[3:4] = (1.0/p.mass)*(gravity+spring+drag)
end
```

### Numerical Solution
```julia
{{< include "../../SpringPendulum/src/SpringPendulum.jl" >}}
```

### Phase Space Trajectory
Plot showing the system evolution in phase space.

![Left: Trajectory plot. Right: Theta vs Time](trajectory_plot.png)

Code corresponding to this:

```julia
function plot_trajectory(sol; title="Spring Pendulum Trajectory")
    a = reduce(hcat, sol.u)'
    x =  a[:, 1]
    y = a[:, 2]
    θ = atan.(a[:, 2], a[:, 1])

    xlimits = (minimum(x)-1, maximum(x)+1)
    ylimits = (minimum(y)-1, maximum(y)+1)

    trajectory_plot = Figure()
    trajectory = Axis(trajectory_plot[1, 1],
        title=title,
        xlabel="X position",
        ylabel="Y position",
        limits=(xlimits, ylimits),
        aspect=1,
    )
    lines!(trajectory, x, y,
        label="Trajectory",
    )
    axislegend(position=:rb)

    trajectory = Axis(trajectory_plot[1, 2],
        title="Theta vs time",
        xlabel="Time",
        ylabel="Theta",
    )
    lines!(trajectory, sol.t, θ)

    return trajectory_plot
end
```

### Animation
The following shows the animation for the solution system. The code corresponding to this animation:

![Spring Pendulum Motion](sol_animation.gif)
<!-- ![Spring Pendulum Motion](springpendulum_motion.mp4) -->

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

    animation = Figure()
    ax = Axis(animation[1, 1], title = @lift("t = $(round($time, digits = 1))"), limits=(xlimits, ylimits), aspect=1)

    scatter!(ax, x, y, color=:red, markersize = 15)
    lines!(ax, line_x, line_y, color=:black)

    framerate = 30
    timestamps = range(0, last(sol.t), step=1/framerate)

    record(animation, filename, timestamps;
            framerate = framerate) do t
        time[] = t
    end

    return animation
end
```

### Observations

1. Energy exchange between potential and kinetic forms
2. Damped oscillations due to viscous friction
3. For some parameters there is weird behaviour at very small scales, like the following. This is probably an artifact of the solver and floating point truncations. I was unable to reproduce this, but I had shown this to Professor Andy and Ganesh Bhaiya.
4. Increasing `c` by a little has a drastic effect
5. The problem was fun to simulate
6. Julia was fun to code in: Libraries were ergonomic to use, DifferentialEquations.jl, and Makie.jl
