"""
Author : VOTRE NOM
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")
include("./customlibs/upper_bound_pl.jl")
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

function printNext(next)
  println("°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°")
  for n in next
    printSolution(n[1])
    println(n[2])
    println(n[3])
  end
  println("°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°")
end

function sortAndFilter(nextNodes, bound)
  nextNodes = sort(nextNodes, lt=(x,y)->isless(y[3], x[3]))
  newNodes = []
  for n in nextNodes
    if (n[3] <= bound)
      push!(newNodes, n)
    end
  end

  # printNext(nextNodes)
  return newNodes
end

function branchAndBound(sol::Solution, eval::Function)
  bound = eval(sol)
  # println("BOUND")
  # println(bound)

  nextNodes = []
  for l in 1:sol.inst.h-sol.inst.ha[1]+1
    for c in 1:sol.inst.w-sol.inst.wa[1]+1
      newSol = copySolution(sol)
      resultPlace = place(newSol, 1, l, c) # First level only
      if (resultPlace)
        newBound = eval(newSol)
        if (newBound <= bound)
          push!(nextNodes, (newSol, 1, newBound))
        end
      end
    end
  end
  newSol = copySolution(sol)
  newBound = eval(newSol)
  if (newBound <= bound)
    push!(nextNodes, (newSol, 1, newBound))
  end

  nextNodes = sortAndFilter(nextNodes, bound)
  if (length(nextNodes) > 0)
    sol = nextNodes[1][1]
    bound = nextNodes[1][3]
  end

  while (length(nextNodes) > 0)
    node = nextNodes[1]
    nSol = node[1]
    a = node[2]

    if (a+1 <= sol.inst.n)
      for l in 1:sol.inst.h-sol.inst.ha[a+1]+1
        for c in 1:sol.inst.w-sol.inst.wa[a+1]+1
          newSol = copySolution(nSol)
          resultPlace = place(newSol, a+1, l, c)
          if (resultPlace)
            newBound = eval(newSol)
            if (newBound <= bound)
              push!(nextNodes, (newSol, a+1, newBound))
              nextNodes = sortAndFilter(nextNodes, bound)
            end
          end
        end
      end
      newSol = copySolution(nSol)
      newBound = eval(newSol)
      if (newBound <= bound)
        push!(nextNodes, (newSol, a+1, newBound))
        nextNodes = sortAndFilter(nextNodes, bound)
      end
      nextNodes = nextNodes[2:end]
      sol = nextNodes[1][1]
      bound = nextNodes[1][3]
    else
      return nSol
    end
  end

  println("END")
  return sol
end

######

@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant
*** DECRIRE VOTRE ALGORITHME ICI en quelques mots ***

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  println("START BRANCH AND BOUND")
  sol = branchAndBound(sol, upperBound)
  println("FINISH BRANCH AND BOUND")
  printSolution(sol)
end

@doc """
Cette fonction est appelée après la fonction `run` et permet de faire de l'affichage et des traitement sur la sortie de la fonction `run` ; sans pour autant affecter son temps de calcul.

Le paramètre cpu time est le temps de calcul de `run`. Les valeurs de `inst` et `sol` sont les mêmes qu’à la sortie de la fonction run. Enfin, `others` est ce qui est renvoyé par la fonction `run`. Vous pouvez ainsi effectuer des tests et afficher des résultats sans affecter le temps de calcul.
""" ->
function post_process(cpu_time::Float64, inst, sol, others)
  println(cpu_time)
  # Remplir la fonction
end

# Ne pas enlever
if length(ARGS) > 0
  input_file = ARGS[1] 
  main(input_file)
end

