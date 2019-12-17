"""
Author : Morvan - Rock
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")

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
  m = Model(with_optimizer(GLPK.Optimizer))
  @variable(m, y[1:inst.n, 1:inst.h, 1:inst.w], Bin)

  @constraint(m, c1[l in 1:inst.h, c in 1:inst.w], sum(y[a, l, c] for a in 1:inst.n) <= 1)
  @constraint(m, c2[a in 1:inst.n], sum(
    y[a, l, c]
    for l in 1:inst.h
    for c in 1:inst.w
  ) <= inst.wa[a]*inst.ha[a])

  # If impossible: no sum, need to have at least 0 to avoid error
  @objective(m, Max, 0+sum(
    get_cost_bis(inst, a, y)
    for a in 1:inst.n
  ))
  optimize!(m)

  println(objective_value(m))
  # println(m)

  return nothing
end

function get_cost_bis(inst, a, y)
  return min(
    inst.ma[a],
    sum(
      y[a, l, c]
      for l in 1:inst.h
      for c in 1:inst.w
    )
  )
end

@doc """
Cette fonction est appelée après la fonction `run` et permet de faire de l'affichage et des traitement sur la sortie de la fonction `run` ; sans pour autant affecter son temps de calcul.

Le paramètre cpu time est le temps de calcul de `run`. Les valeurs de `inst` et `sol` sont les mêmes qu’à la sortie de la fonction run. Enfin, `others` est ce qui est renvoyé par la fonction `run`. Vous pouvez ainsi effectuer des tests et afficher des résultats sans affecter le temps de calcul.
""" ->
function post_process(cpu_time::Float64, inst, sol, others)
  
  # Run a renvoyé le modèle et ses variables, qui ont été mis dans others.
  # m, x, y, z = others

  # print(m)

  # println()

  # println("TERMINAISON : ", termination_status(m))
  # println("OBJECTIF : $(objective_value(m))")
  # println("VALEURS de x : $(value.(x))")
  # println("VALEURS de y : $(value.(y))")
  # println("VALEURS de z : $(value.(z))")

  # println("Temps de calcul : $cpu_time.")

end

# Ne pas enlever
if length(ARGS) > 0
  input_file = ARGS[1] 
  main(input_file)
end

