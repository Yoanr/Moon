"""
Author : ROCK - MORVAN
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")

######
function printMoonMap(moonMap)
  println("=============")
  for h in 1:length(moonMap[1:end, 1])
    println(moonMap[h, 1:end])
  end
  println("=============")
end

function calcMoonTotal(moonMap, moonPrices, ma)
  costs = zeros(Int64, 1, length(ma))
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  for x in 1:w
    for y in 1:h
      if moonMap[x, y] != 0
        costs[moonMap[x, y]] = costs[moonMap[x, y]] + moonPrices[x][y]
      end
    end
  end

  price = 0
  for id in 1:length(costs)
    price = price + min(costs[id], ma[id])
  end

  return price
end

#moonMap : tableau qui represente la lune avec les cases deja choisie ou non
#annonceur : [n(a),W(a),H(a),x(a),y(a)] tuple ou a est un annonceur
function checkAddAdv(moonMap,annonceur)
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  for x in annonceur[5]:annonceur[5]+annonceur[3]-1
    for y in annonceur[4]:annonceur[4]+annonceur[2]-1
      if x > h
        return nothing
      elseif y > w
        return nothing
      elseif moonMap[x, y] != 0
        return nothing
      end
    end
  end

  for x in annonceur[5]:annonceur[5]+annonceur[3]-1
    for y in annonceur[4]:annonceur[4]+annonceur[2]-1
        moonMap[x, y] = annonceur[1]
    end
  end
  return moonMap;
end

function listPositions(n, wa, ha, w, h, moonMap)
  if (n === 0)
    return [moonMap]
  else
    moonMaps = []
    for x in 1:w
      for y in 1:h
        adv = (n, wa[n], ha[n], x, y)
        println(adv)
        newMoonMap = checkAddAdv(copy(moonMap), adv)
        if (newMoonMap !== nothing)
          printMoonMap(newMoonMap)
          moonMaps = vcat(moonMaps, listPositions(n-1, wa, ha, w, h, newMoonMap))
        else
          println("=============")
          println("nothing")
          println("=============")
        end
      end
    end
    moonMaps = vcat(copy(moonMaps), listPositions(n-1, wa, ha, w, h, moonMap))
    return moonMaps
  end
end

######

@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant
*** DECRIRE VOTRE ALGORITHME ICI en quelques mots ***

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  moonMap = zeros(Int64, inst.h, inst.w)
  moonMaps = listPositions(inst.n, inst.wa, inst.ha, inst.w, inst.h, moonMap)

  println("/////////// RESULTATS POSSIBLES /////////////////")
  best = moonMap
  bestValue = 0
  for map in moonMaps
    printMoonMap(map)
    price = calcMoonTotal(map, inst.ω, inst.ma)
    println(price)
    if price > bestValue
      bestValue = price
      best = map
    end
  end

  println("/////////// RESULTAT OPTIMAL /////////////////")
  printMoonMap(best)
  println(bestValue)  
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

