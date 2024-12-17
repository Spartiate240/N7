import numpy as np

# Composants du réseau: liés par des liens: chaque composant d'un ligne est lié à tout ceux de la ligne suivante
# Et PTS1 lié à PTS2
#      PS4    PS5

# PTSI1          PTS2

#PS1      PS2      PS3

# Matrice des liens entre les composants
#      PS1   PS2   PS3   PS4   PS5   PTS1   PTS2
# PS1   0     0     0     0     0      1      1
# PS2   0     0     0     0     0      1      1
# PS3   0     0     0     0     0      1      1
# PS4   0     0     0     0     0      1      1
# PS5   0     0     0     0     0      1      1
# PTS1  1     1     1     1     1      0      1
# PTS2  1     1     1     1     1      1      0


liens_ex = [[0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 1, 1],
            [1, 1, 1, 1, 1, 0, 1],
            [1, 1, 1, 1, 1, 1, 0]]

# Fonction qui retourne la liste des noeuds adjacents pour chaque noeud
# Entrée: liens_ex: matrice des liens entre les composants
# Sortie: liste_adj: liste des noeuds adjacents pour chaque noeud
def liste_adj(liens_ex):
    n = len(liens_ex)
    liste_adj = []

    # On parcours la liste des liens et on ajoute les noeuds adjacents pour chaque noeud
    for i in range(n):
        liste_adj.append([])
        for j in range(n):
            if liens_ex[i][j] == 1:
                liste_adj[i].append(j)
    return liste_adj

# Test de la fonction liste_adj
# Affichage attendu: [[5, 6], [5, 6], [5, 6], [5, 6], [5, 6], [0, 1, 2, 3, 4, 6], [0, 1, 2, 3, 4, 5]]
#print(liste_adj(liens_ex))


# Algorithme de recherche de tous les chemins possibles entre deux noeuds
# Entrée: liste_adj: liste des noeuds adjacents pour chaque noeud
#         appellant: composant appelant/ origine
#         appele: composant appelé/ arrivée
# Sortie: chemins_p: liste des chem
def tout_chemins(liste_adj, appellant, appele):
    chemins_p = []

    return chemins_p

# Algorithme du routage en partage de charge
# Entrée: liens_ex: matrice des liens entre les composants
#         appel: composant appelant/ origine
#         appele: composant appelé/ arrivée
# Sortie: chemin: liste des composants du chemin de routage
def partage_charge(liste_adj, appellant,appele) :
    nb_composants = len(liens_ex)
    chemins_s = [[]] # liste des listes prises: forme d'une liste de la liste:
                  # [ %charge, noeud1, ... , noeudn]

    ## Déterminer les chemins possibles
    chemins_p = [] # liste des chemins possibles
    chemins_p = tout_chemins(liste_adj, appellant, appele)
    print(chemins_p)


    

    

    return chemins_s


# Test de la fonction partage_charge
liste_adj = liste_adj(liens_ex)
partage_charge(liens_ex, 0, 6)