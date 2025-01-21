import numpy as np
import random

#
# quelle matrice?
#
#



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

# Matrice des capacités (en appels simultanés)
capacites = [[0, 0, 0, 0, 0, 10, 10],
             [0, 0, 0, 0, 0, 10, 10],
             [0, 0, 0, 0, 0, 10, 10],
             [0, 0, 0, 0, 0, 10, 10],
             [0, 0, 0, 0, 0, 10, 10],
             [10, 10, 10, 10, 10, 0, 100],
             [10, 10, 10, 10, 10, 100, 0]]

# Liste des utilisateurs, servira pour virer les chemins incluant des utilisateurs non concernés
# par l'appel
utilisateurs = [0, 1, 2]



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
def trouver_chemins(graph, source, destination, chemin_actuel=[]):
    chemin_actuel = chemin_actuel + [source]  # Ajouter le nœud actuel au chemin
    if source == destination:  # Si on atteint le nœud de destination, retourner le chemin
        return [chemin_actuel]
    
    chemins = []  # Liste pour stocker les chemins
    for voisin in graph[source]:
        if voisin not in chemin_actuel:  # Éviter les boucles
            chemins += trouver_chemins(graph, voisin, destination, chemin_actuel)
    
    return chemins
trouver_chemins



# On garde que les chemins possibles:
# On vire donc ceux de taille paire (qui donc forcément passent par 2 PTS d'affilée) ############################ Sur???
# Ceux qui passent par un le PS (1, 2 ou 3) qui n'est ni source, ni destinaion
# Donc ceux qui contiennent l'indice dans [0 1 2] différent de source/dest
def chemins_possible(listes):
    chemins_possibles = []
    concerne = [] # Utilisateurs concernés
    concerne.append(listes[0][0]) # Appelant
    concerne.append(listes[0][-1]) # appelé
    virer = []

    # Liste des indices excluant, dans notre cas: 1 seul
    for i in utilisateurs:
        if i not in concerne:
            virer.append(i)
    print(listes)

    # Parcourir toutes les listes et ne prendre celles qui correspondent.
    for i in listes:
        for j in virer:
            # Si contient le 3e utilisateur, on vire
            if j in i:
                listes.remove(i)
                print(i)
        
        # Si chemin de longeur paire
        if len(i) % 2 == 0 and i in listes:
            listes.remove(i)
    
    return listes


# Test de la fonction partage_charge
liste_adj = liste_adj(liens_ex)
tous_chemins = trouver_chemins(liste_adj, 1, 4)
chemins_possibles = chemins_possible(tous_chemins)
print(chemins_possibles)

#OK



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
    chemins_p = trouver_chemins(liste_adj, appellant, appele)
    print(chemins_p)
    return chemins_s




# Fonction qui génère des appels aléatoires
# Entrée: nb_appels: nombre d'appels à générer
#         n: nombre de composants dans le réseau
# Sortie: appels: liste des appels générés
def gene_appel(nb_appels, n):
    appels = []

    for _ in range(nb_appels):
        source = random.randint(0, n - 1)
        destination = random.randint(0, n - 1)
        # Evite qu'on ait un appel ayant même source et destination
        while destination == source:
            destination = random.randint(0, n - 1)

        duree = random.uniform(1, 5)
        appel = [source, destination, duree]
        appels.append(appel)
    return appels


# Test de la fonction gene_appel
test_appels = gene_appel(10, 7)
print("Test Appels:")
print(test_appels)
# OK
