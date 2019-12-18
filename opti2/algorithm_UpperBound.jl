"""
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

  plotWanted = advColumn * advLine
    for x in 1:h
     for y in 1:w
        if moonMap[x,y] == index
          plotWanted  = plotWanted - 1
        end
      end
    end
   # print(plotWanted)
   # print(" ")
    if plotWanted > 0
      return true
    end
    return false
end

function advertisersCanBuy(n,moonMap,moonPrices,advsPrice)
  for index in 1:n
    budget_used = alreadyPaidN(index,moonMap,moonPrices)
    if  budget_used < advsPrice[index]
      return true
    end
  end
  return false
end

function alreadyPaidN(index,moonMap,moonPrices)
  h = length(moonMap[1:end, 1])
  w = length(moonMap[1, 1:end])
  localMa = 0
  for x in 1:h
     for y in 1:w
        if moonMap[x,y] == index
          localMa  = localMa + moonPrices[x][y]
        end
      end
    end
    return localMa
end

function getUpperBound(inst)

  moonPrices = copy(inst.ω)
  advsPrice = copy(inst.ma)
  advsColumn = copy(inst.wa)
  advsLine = copy(inst.ha)
  n = inst.n
  UpperBound = 0
  h = inst.h
  w = inst.w
  moonMap = zeros(Int64, h, w)


  while unsoldPlot(moonMap) && advertisersCanBuy(n,moonMap,moonPrices,advsPrice)
   # print(unsoldPlot(moonMap))
    # print(advertisersCanBuy(n,moonMap,moonPrices,advsPrice))
  gain = 0
  advertiser = 1
  localx = 1
  localy = 1

    for x in 1:h
      for y in 1:w
        if moonMap[x,y] == 0
          for index in 1:n
            if advertiserNCanBuy(index,moonMap,advsColumn[index],advsLine[index])
              budget_used = alreadyPaidN(index,moonMap,moonPrices)
              print("budget_used :")
              print(budget_used)
              print("\n")
             # print("\n")
              newGain = min(advsPrice[index] - budget_used, moonPrices[x][y])
             # print("newGain :")
              #print(newGain)
              #print("\n")
             # print("gain :")
             # print(gain)
             # print("\n")
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
    end
     # print(localx)
     # print(localy)

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
   print("upperBound : ")
  print(upperBound)
  print("\n")
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

