import numpy as np
import random
# Matrice Réseau:
#       CTS1      CTS2
#  CA1       CA2         CA3 
#   U1        U2          U3

# Matrice des liens:
#      CA1   CA2   CA3   CTS1   CTS2
# CA1   0     1     0     1      1
# CA2   1     0     1     1      1
# CA3   0     1     0     1      1
# CTS1  1     1     1     0      1
# CTS2  1     1     1     1      0
liens_rezo = [[0, 1, 0, 1, 1],
              [1, 0, 1, 1, 1],
              [0, 1, 0, 1, 1],
              [1, 1, 1, 0, 1],
              [1, 1, 1, 1, 0]]
# Matrice des capacités (en appels simultanés)
capacites = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]


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

liste_adj = liste_adj(liens_rezo)
tous_chemins = trouver_chemins(liste_adj, 1, 4)
print(tous_chemins)
#OK

# Comme routage statique: on définit préalabement les chemins à prendre
# On les choisi en fonction de la charge des liens, on prends ceux avec la plus grande charge
# C'est moche mais c'est le statique
def routage_statique(appellant, appele):
    chemin = []
    # Si appel de U1 à U2: CA1 -> CTS1 -> CA2
    if appellant == 0 and appele == 1:
        chemin = [0, 3, 1]
    # Si appel de U1 à U3: CA1 -> CTS2 -> CTS1 -> CA3
    elif appellant == 0 and appele == 2:
        chemin = [0, 4, 3, 2]
    # Si appel de U2 à U3: CA2 -> CTS2 -> CA3
    elif appellant == 1 and appele == 2:
        chemin = [1, 4, 3]
    
    # On inverse le sens des appels pour les autres cas
    # Si appel de U2 à U1: CA2 -> CTS1 -> CA1
    elif appellant == 1 and appele == 0:
        chemin = [1, 3, 0]
    # Si appel de U3 à U1: CA3 -> CTS1 -> CTS2 -> CA1
    elif appellant == 2 and appele == 0:
        chemin = [2, 3, 4, 0]
    # Si appel de U3 à U2: CA3 -> CTS2 -> CA2
    elif appellant == 2 and appele == 1:
        chemin = [2, 4, 1]

    # Si le chemin est pas possible: []
    for i in len(chemin):
        if capacites[chemin[i]][chemin[i+1]] == 0:
            return []
    return chemin




# Algorithme du routage en partage de charge
# Entrée: liens_ex: matrice des liens entre les composants
#         appel: composant appelant/ origine
#         appele: composant appelé/ arrivée
# Sortie: chemin: liste des composants du chemin de routage
def partage_charge(liste_adj, appellant,appele) :
    nb_composants = len(liens_rezo)
    chemins_s = [[]] # liste des listes prises: forme d'une liste de la liste:
                  # [ %charge, noeud1, ... , noeudn]

    ## Déterminer les chemins possibles
    chemins_p = [] # liste des chemins possibles
    chemins_p = trouver_chemins(liste_adj, appellant, appele)

    # Virer ceux qui ont qqpart une capacité nulle:
    for i in range(len(chemins_p)):
        if capacites[chemins_p[i][0]][chemins_p[i][1]] == 0:
            chemins_p.remove(chemins_p[i])
        

    return chemins_s


# Fonction qui génère des appels aléatoires
# Entrée: nb_appels: nombre d'appels à générer
#         n: nombre de composants dans le réseau
# Sortie: appels: liste des appels générés
def gene_appel(nb_appels, n):
    appels = []

    for _ in range(nb_appels):
        source = random.randint(0, 2)
        destination = random.randint(0, 2)
        # Evite qu'on ait un appel ayant même source et destination
        while destination == source:
            destination = random.randint(0, 2)

        duree = random.uniform(1, 5)
        appel = [source, destination, duree]
        appels.append(appel)
    return appels


# Test de la fonction gene_appel
test_appels = gene_appel(10, 7)
#print("Test Appels:")
#print(test_appels)
# OK
    



##############################################################
#                   Test des routages
##############################################################

# Variables:
nb_appels = [200*(i+1) for i in range(50)] # par "heure"



for i in nb_appels:
    appels_cours_stat = []
    appels_cours_par_charge = []
    appels_cours_dyn = []

    ### Liste des chemins où l'indice de la liste des chemins corresponds au chemin emprunté pour l'indice de l'appel?


    rejets_par_char = 0
    rejets_stat = 0
    rejets_dyn = 0
    # Boucle for dans la durée
    
    # Par minute:
    gene_min = int(i/60)
    # Les gene_min appels
    generee = gene_appel(gene_min,5)

    for n in len(generee):
        # Déterminer chemin de routage pour chaque appel généré et par méthode de routage
        chemin_stat = routage_statique(generee[n][0], generee[n][1])
        chemin_par_charge = partage_charge(liste_adj, generee[n][0], generee[n][1])
        #chemin_dyn = routage_dynamique(generee[n][0], generee[n][1])


        # Rejet de l'appel si pas de chemin possible
        if chemin_par_charge == []:
            rejets_par_char += 1
        else:
            appels_cours_par_charge.append(generee(n))
        if chemin_stat == []:
            rejets_stat += 1
        else:
            appels_cours_stat.append(generee(n))

        #if chemin_dyn == []:
        #    rejets_dyn += 1
        #else:
        #    appels_cours_dyn.append(generee(n))


    
    # A la fin de la minute, MAJ durée + suppression appels terminés
    for j in appels_cours_dyn:
        j[2] -= 1
        if j[2] == 0:
            appels_cours_dyn.remove(j)
    for j in appels_cours_stat:
        j[2] -= 1
        if j[2] == 0:
            appels_cours_stat.remove(j)
    for j in appels_cours_par_charge:
        j[2] -= 1
        if j[2] == 0:
            appels_cours_par_charge.remove(j)
    
            # Mettre à jour les charges des liens

        