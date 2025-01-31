module MinimumDistanceBetweenTwoLines

using Symbolics
using LinearAlgebra

# problem setup  # @variables l₁ l₂ p⃗₁[1:n] p⃗₂[1:n]
n = 3
@variables r⃗ₛ[1:n] r⃗ₜ[1:n] r⃗ᵤ[1:n] r⃗ᵥ[1:n]
@variables λ₁ λ₂
p⃗₁ = r⃗ₛ + λ₁ * (r⃗ₜ - r⃗ₛ)
p⃗₂ = r⃗ᵤ + λ₂ * (r⃗ᵥ - r⃗ᵤ)

# D(λ₁, λ₂) = norm(s⃗)
s⃗ = p⃗₂ - p⃗₁
D² = dot(s⃗, s⃗)

# evaluation
subs = Dict(
    r⃗ₛ => [0.0, 0.0, 0.0],
    r⃗ₜ => [1.0, 0.0, 0.0],
    r⃗ᵤ => [0.0, 0.0, 1.0],
    r⃗ᵥ => [0.0, 1.0, 2.0],
    # λ₁ => 3,
    # λ₂ => 4,
)
D²_eval = Symbolics.scalarize(substitute.(Symbolics.scalarize(D²), Ref(subs)))
∇D² = Symbolics.gradient(D²_eval, [λ₁, λ₂])

eq = ∇D² .~ 0

result = Dict([λ₁, λ₂] .=> symbolic_linear_solve(eq, [λ₁, λ₂]))

p⃗₁_eval, p⃗₂_eval = substitute.(Symbolics.scalarize.([p⃗₁, p⃗₂]), Ref(merge(subs, result)))

ŝ = substitute.(D²_eval, Ref(result))

println(ŝ)
println(p⃗₁_eval, p⃗₂_eval)



end # module MinimumDistanceBetweenTwoLines
