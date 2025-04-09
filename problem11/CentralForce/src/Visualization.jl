module Visualization

import GLMakie

function plot_trajectory(sol)
    sol = reduce(hcat, sol.u)'
	r = view(sol, :, 1:2)
	# v = view(sol, :, 3:4)

	trajectory = GLMakie.Figure()
	ax = GLMakie.Axis(
		trajectory[1,1],
		title="Trajectory Central Force",
		aspect=GLMakie.DataAspect(),
	)

	x = view(r, :, 1)
	y = view(r, :, 2)
	GLMakie.lines!(ax, x, y)

	return trajectory
end

end # module Visualization
