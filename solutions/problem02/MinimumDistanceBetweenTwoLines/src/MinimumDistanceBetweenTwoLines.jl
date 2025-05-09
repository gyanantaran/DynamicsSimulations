module MinimumDistanceBetweenTwoLines

import Symbolics
import LinearAlgebra

# problem setup
const N = 3
Symbolics.@variables r⃗ₛ[1:N] r⃗ₜ[1:N] r⃗ᵤ[1:N] r⃗ᵥ[1:N]
Symbolics.@variables λ₁ λ₂

p⃗₁ = r⃗ₛ + λ₁ * (r⃗ₜ - r⃗ₛ)
p⃗₂ = r⃗ᵤ + λ₂ * (r⃗ᵥ - r⃗ᵤ)
s⃗ = p⃗₂ - p⃗₁
D² = LinearAlgebra.dot(s⃗, s⃗)
D² = Symbolics.scalarize(D²)
∇D² = Symbolics.gradient(D², [λ₁, λ₂])
eq = ∇D² .~ 0

lambdas_symbolic = Dict([λ₁, λ₂] .=> Symbolics.symbolic_linear_solve(eq, [λ₁, λ₂]))
p̂₁_symbolic, p̂₂_symbolic = Symbolics.substitute.([p⃗₁, p⃗₂], Ref(lambdas_symbolic))
ŝ_symbolic = Symbolics.substitute.(D², Ref(lambdas_symbolic))


# evaluation
subs = Dict(
    r⃗ₛ => [0.0, 0.0, 0.0],
    r⃗ₜ => [1.0, 0.0, 0.0],
    r⃗ᵤ => [0.0, 0.0, 1.0],
    r⃗ᵥ => [0.0, 1.0, 2.0],
    # λ₁ => 3,
    # λ₂ => 4,
)
∇D²_eval = Symbolics.substitute.(∇D², Ref(subs))

eq_eval = Symbolics.substitute.(eq, Ref(subs))

result_eval = Dict(
    symbol => Symbolics.substitute(expresion, subs) for
    (symbol, expresion) in lambdas_symbolic
)
merged_eval = merge(subs, result_eval)

ŝ_eval = Symbolics.substitute.(D², Ref(merged_eval))
p̂₁_eval, p̂₂_eval = Symbolics.substitute.([p⃗₁, p⃗₂], Ref(merged_eval))

println("=== Substituted results: =====")
println("Λ̂  : ", result_eval)
println("ŝ  = ", ŝ_eval)
println("p̂₁ = ", p̂₁_eval)
println("p̂₂ = ", p̂₂_eval)

println("\n=== Symbolic results: =====")
println("Λ̂  : ", lambdas_symbolic)
println("ŝ  = ", Symbolics.scalarize(ŝ_symbolic))
println("p̂₁ = ", Symbolics.scalarize(p̂₁_symbolic))
println("p̂̂₂ = ", Symbolics.scalarize(p̂₂_symbolic))

end # module MinimumDistanceBetweenTwoLines
