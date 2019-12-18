"""
Author : VOTRE NOM
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")
include("./customlibs/upper_bound.jl")
include("./customlibs/copy_solution.jl")
include("./customlibs/print_solution.jl")

######

function vp(inst, i::Int, l::Int, c::Int)
  if i < 1 || i > inst.n
    return false
  end
  if c < 1 || c > inst.w - inst.wa[i] + 1
    return false
  end
  if l < 1 || l > inst.h - inst.ha[i] + 1
    return false
  end
  return true
end

function branchAndBound(sol::Solution, eval::Function)
  place(sol, 1, 2, 3)
  bound = nothing

  for a in 2:sol.inst.n
    aSol = copySolution(sol)
    lowerBound = bound
    for l in 1:sol.inst.h-sol.inst.ha[a]+1
      for c in 1:sol.inst.w-sol.inst.wa[a]+1
        newSol = copySolution(aSol)
        if (vp(newSol.inst, a, l, c))
          place(newSol, a, l, c)
          newBound = eval(newSol)
          if (bound == nothing || newBound < bound)
            println("< NEW BOUND")
            println(newBound)
            printSolution(newSol)
            println("NEW BOUND >")
            lowerBound = newBound
            aSol = newSol
          end
        end
      end
    end
    bound = lowerBound
    sol = aSol
  end

  return sol
end

######

@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant
*** DECRIRE VOTRE ALGORITHME ICI en quelques mots ***

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  finalSol = branchAndBound(sol, upperBound)
  printSolution(finalSol)
end

@doc """
Cette fonction est appelée après la fonction `run` et permet de faire de l'affichage et des traitement sur la sortie de la fonction `run` ; sans pour autant affecter son temps de calcul.

Le paramètre cpu time est le temps de calcul de `run`. Les valeurs de `inst` et `sol` sont les mêmes qu’à la sortie de la fonction run. Enfin, `others` est ce qui est renvoyé par la fonction `run`. Vous pouvez ainsi effectuer des tests et afficher des résultats sans affecter le temps de calcul.
""" ->
function post_process(cpu_time::Float64, inst, sol, others)
  # Remplir la fonction
end

# Ne pas enlever
if length(ARGS) > 0
  input_file = ARGS[1] 
  main(input_file)
end

