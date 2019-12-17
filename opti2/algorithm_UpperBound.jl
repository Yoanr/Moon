upperBound"""
Author : ROCK - MORVAN
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""
# Ne pas enlever
include("./main.jl")

######
function unsoldPlot(moonMap)
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  for x in 1:h
    for y in 1:w
      if moonMap[x,y] == 0
        return true
      end
    end
  end
  return false
end

function advertiserNCanBuy(index,moonMap,advColumn,advLine)
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  plotWanted = advColumn * advLine[index]
    for x in 1:h
     for y in 1:w
        if moonMap[x,y] == index
          plotWanted  = plotWanted - 1
        end
      end
    end
    if plotWanted > 0
      return true
    end
    return false
end

function advertisersCanBuy(n,moonMap,advsColumn,advsLine)
  for index in 1:n
    if advertiserNCanBuy(index,moonMap,advColumn[index],advLine[index])
      return true
    end
  end
  return false
end

function alreadyPaidN(index,moonMap,moonPrices,ma)
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  localMa = ma
  for x in 1:h
     for y in 1:w
        if moonMap[x,y] == index
          localMa  = localMa - moonPrices[x][y]
        end
      end
    end
    return localMa
end

function getUpperBound(inst,sol)
  moonPrices = inst.ω
  advsPrice = inst.ma
  advsColumn = inst.wa
  advsLine = inst.ha
  n = inst.n
  UpperBound = 0
  h = inst.h
  w = inst.w
  moonMap = zeros(Int64, h, w)

  while unsoldPlot(moonMap) && advertisersCanBuy(n,moonMap,advsColumn,advsLine)
  gain = 0
  advertiser = 0
  localx = 0
  localy = 0

  for x in 1:h
    for y in 1:w
      if moonMap[x,y] == 0
        for index in 1:n
          if advertiserNCanBuy(index,moonMap,advColumn[index],advLine[index])
            budget_used = alreadyPaid(index,moonMap,moonPrices,advColumn[index],advLine[index])
            newGain = min(advsPrice[index] - budget_used, moonPrices[x][y])
            if newGain > gain
              gain = newGain
              advertiser = index
              localx = x
              localy = y
            end
          end
        end
      end
    end
    moonMap[localx,localy] = advertiser
    UpperBound = UpperBound + gain
  end

  return UpperBound
end


@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant
*** DECRIRE VOTRE ALGORITHME ICI en quelques mots ***

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  upperBound = getUpperBound(inst)
  print(upperBound)
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

