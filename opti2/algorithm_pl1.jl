"""
Author : Morvan - Rock
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")
include("./customlibs/print_solution.jl")

######
# VOTRE CODE


println("Chargement de JuMP")
using JuMP
println("Chargement de GLPK")
using GLPK
println("Chargé")

######

@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant

Cette fonction fait n'importe quoi, c'est juste un exempel de programme linéaire.

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  println("START")
  m = Model(with_optimizer(GLPK.Optimizer))
  @variable(m, y[1:inst.n, 1:inst.h, 1:inst.w], Bin)
  @variable(m, x[1:inst.n, 1:inst.h, 1:inst.w], Bin)

  @constraint(m, c1[a in 1:inst.n], sum(y[a, l, c]
  for c in 1:(inst.w-inst.wa[a]+1)
  for l in 1:(inst.h-inst.ha[a]+1)) <= 1)
  @constraint(m, c2[l in 1:inst.h, c in 1:inst.w], sum(x[a, l, c] for a in 1:inst.n) <= 1)
  @constraint(m, c3[a in 1:inst.n, l in 1:(inst.h-inst.ha[a]+1), c in 1:(inst.w-inst.wa[a]+1), i in 0:(inst.ha[a]-1), j in 0:(inst.wa[a]-1)], y[a, l, c] <= x[a, l+i, c+j])
  @constraint(m, c4[a in 1:inst.n, l in 1:inst.h, c in 1:inst.w], sum(y[a, l-i, c-j]
  for j in 0:(min(c, inst.wa[a])-1)
  for i in 0:(min(l, inst.ha[a])-1)) >= x[a, l, c])

  # If impossible: no sum, need to have at least 0 to avoid error
  @objective(m, Max, 0+sum(
    sum(
      sum(
        get_cost(inst, a, l, c)*y[a, l, c]
      for c in 1:(inst.w-inst.wa[a]+1))
    for l in 1:(inst.h-inst.ha[a]+1))
  for a in 1:inst.n))
  optimize!(m)

  # println(objective_value(m))
  places = value.(y)

  for a in 1:inst.n
    for l in 1:inst.h
      for c in 1:inst.w
        if (places[a, l, c] == 1)
          place(sol, a, l, c)
        end
      end
    end
  end

  println("END")

  printSolution(sol)
end

@doc """
Cette fonction est appelée après la fonction `run` et permet de faire de l'affichage et des traitement sur la sortie de la fonction `run` ; sans pour autant affecter son temps de calcul.

Le paramètre cpu time est le temps de calcul de `run`. Les valeurs de `inst` et `sol` sont les mêmes qu’à la sortie de la fonction run. Enfin, `others` est ce qui est renvoyé par la fonction `run`. Vous pouvez ainsi effectuer des tests et afficher des résultats sans affecter le temps de calcul.
""" ->
function post_process(cpu_time::Float64, inst, sol, others)
  println(cpu_time)
end

# Ne pas enlever
if length(ARGS) > 0
  input_file = ARGS[1] 
  main(input_file)
end

