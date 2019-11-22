"""
Author : ROCK - MORVAN
Projet OPTIMISATION 2 - ENSIIE - 2019-2020
"""

# Ne pas enlever
include("./main.jl")

######

#moonMap : tableau qui represente la lune avec les cases deja choisie ou non
#annonceur : [n(a),W(a),H(a),x(a),y(a)] tuple ou a est un annonceur
function checkAddAdv(moonMap,annonceur)
length = length(moonMap)
for x in annonceur[4]:annonceur[4]+annonceur[2]
  for y in annonceur[5]:annonceur[5]+annonceur[3]
    if x > length
      return nothing
    elseif y > length
      return nothing
    elseif moonMap[x][y] != 0
      return nothing
    else
      moonMap[x][y] = annonceur[1]
return moonMap;
end

######

@doc """
Modifie la solution sol de l'instance inst avec l'algorithme suivant
*** DECRIRE VOTRE ALGORITHME ICI en quelques mots ***

Cette fonction peut renvoyer n'importe quel type de variable (dont rien du tout), qui sera ensuite traité dans post_process. 
""" ->
function run(inst, sol)
  # Remplir la fonction
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

