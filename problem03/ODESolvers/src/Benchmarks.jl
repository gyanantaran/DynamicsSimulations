module Benchmarks

using LinearAlgebra

using ..ProblemTypes

tail_match(
    sol1::ProblemTypes.Solution,
    sol2::ProblemTypes.Solution,
)::ProblemTypes.AbsError = norm(sol2[end] - sol1[end])

# function slither(sol1::ProblemTypes.Solution, sol2::ProblemTypes.Solution)::ProblemTypes.SolutionDifference
#     Δt = 
#     cummulative_slither = 
# end

# Note: returns abs difference of neighbouring step size solutions
# step sizes should be monotonic
function benchmark(
    solver::ProblemTypes.Solver,
    problem::ProblemTypes.Prob,
    step_sizes::ProblemTypes.StepSizes,
)::ProblemTypes.BenchmarkResult
    @assert length(step_sizes) > 1 "Have to provide atleast two step sizes"
    benchmark_results = zeros(length(step_sizes) - 1)

    # ugly
    prev_sol = solver(problem, step_sizes[1])
    step_sizes = step_sizes[2:end]
    for (i, Δh) in enumerate(step_sizes)
        cur_sol = solver(problem, Δh)
        benchmark_results[i] = tail_match(cur_sol, prev_sol)
        prev_sol = cur_sol
    end

    return benchmark_results
end

end # module Benchmarks
