module Visualization
using Plots;
export plot_trajectory;

function plot_trajectory(sol; title="Projectile Motion")
    a = reduce(hcat, sol.u)';
    display(plot(view(a, :, 1), view(a, :, 2)))
end

end
