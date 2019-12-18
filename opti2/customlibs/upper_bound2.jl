"""
Author : ROCK - MORVAN
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

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


@doc """
Cette fonction renvoie True si l'annonceur d'indice "index" à acheté la quantité de case qu'ils voulait, False sinon

argument :
index ->  indice dans le tableau des annonceurs
moonMap -> tableau de tableau representant la position des annonceurs sur la lune
advColumn -> tableau 2d contenant le nombre de colonnes du rectangle que chaque annonceur souhaite acheter
advLine -> tableau 2d contenant le nombre de ligne du rectangle que chaque annonceur souhaite acheter

renvoi :
Bool -> True / False

""" ->
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

    if plotWanted > 0
      return true
    end
    return false
end

@doc """
Cette fonction renvoie True si tout les annonceurs ont acheté la quantité de case qu'ils voulaient, False sinon

argument :
n ->  nombre d'annonceurs
moonMap -> tableau de tableau representant la position des annonceurs sur la lune
advColumn -> tableau 2d contenant le nombre de colonnes du rectangle que chaque annonceur souhaite acheter
advLine -> tableau 2d contenant le nombre de ligne du rectangle que chaque annonceur souhaite acheter

renvoi :
Bool -> True / False

""" ->
function advertisersCanBuy(n,moonMap,advColumn,advLine)
   h = length(moonMap[1:end, 1])
   w = length(moonMap[1, 1:end])
   for index in 1:n
     if advertiserNCanBuy(index,moonMap,advColumn[index],advLine[index])
       return true
     end
   end
   return false
end

@doc """
Cette fonction renvoie True si tout les annonceurs ont utilisé tout leurs argents, False sinon

argument :
n ->  nombre d'annonceurs
moonMap -> tableau de tableau representant la position des annonceurs sur la lune
moonPrices -> tableau 2d contenant le poids de chaque case sur la lune
advsPrice -> tableau 2d contenant l'argent total possédé pour chaque annonceur

renvoi :
Bool -> True / False

""" ->
function alreadyPaid(n,moonMap,moonPrices,advsPrice)
   h = length(moonMap[1:end, 1])
   w = length(moonMap[1, 1:end])
   for index in 1:n
     budget_used = alreadyPaidN(index,moonMap,moonPrices)
     if  budget_used < advsPrice[index]
       return true
     end
   end
   return false
end


@doc """
Cette fonction renvoi la somme payé par l'annonceur  d'indice "index"

argument :
index ->  indice dans le tableau des annonceurs
moonMap -> tableau de tableau representant la position des annonceurs sur la lune
moonPrices -> tableau 2d contenant le poids de chaque case sur la lune

renvoi :
Int64 -> Borne supérieur

""" ->
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

@doc """
Cette fonction renvoi la borne supérieur du problème Moon Ad pour une instance donnée en argument

argument :
inst -> Instance de Moon Ad

renvoi :
Int64 -> Borne supérieur

""" ->
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


  while unsoldPlot(moonMap) && advertisersCanBuy(n,moonMap,advsColumn,advsLine) && alreadyPaid(n,moonMap,moonPrices,advsPrice)
  gain = 0
  advertiser = 1
  localx = 1
  localy = 1

    for x in 1:h
      for y in 1:w
        if moonMap[x,y] == 0
          for index in 1:n
            if advertiserNCanBuy(index,moonMap,advsColumn[index],advsLine[index]) || alreadyPaidN(index,moonMap,moonPrices) < advsPrice[index]
              budget_used = alreadyPaidN(index,moonMap,moonPrices)
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
    end
      moonMap[localx,localy] = advertiser
      UpperBound = UpperBound + gain
  end
  return UpperBound
end
