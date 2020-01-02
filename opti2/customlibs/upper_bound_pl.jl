println("Chargement de JuMP")
using JuMP
println("Chargement de GLPK")
using GLPK
println("Chargé")

######

function upperBound(sol)
  inst = sol.inst
  m = Model(with_optimizer(GLPK.Optimizer))
  @variable(m, y[1:inst.n, 1:inst.h, 1:inst.w], Bin)
  @variable(m, w[1:inst.n], Int)

  @constraint(m, c1[l in 1:inst.h, c in 1:inst.w], sum(y[a, l, c] for a in 1:inst.n) <= 1)
  @constraint(m, c2[a in 1:inst.n], sum(
    y[a, l, c]
    for l in 1:inst.h
    for c in 1:inst.w
  ) <= inst.wa[a]*inst.ha[a])
  @constraint(m, c3[a in 1:inst.n], w[a] <= inst.ma[a])
  @constraint(m, c4[a in 1:inst.n], w[a] <= sum(
    inst.ω[l][c] * y[a, l, c]
    for l in 1:inst.h
    for c in 1:inst.w
  ))

  # If impossible: no sum, need to have at least 0 to avoid error
  @objective(m, Max, 0+sum(
    w[a]
    for a in 1:inst.n
  ))
  optimize!(m)

  return objective_value(m)
end
