import numpy as np
import random
import time
import matplotlib.pyplot as plt
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
capacites_stat = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
            
capacites_par = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
            
capacites_adapt = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
            
# Tests et affichage des résultats
nb_appels = 100


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
#Affichage attendu: [[5, 6], [5, 6], [5, 6], [5, 6], [5, 6], [0, 1, 2, 3, 4, 6], [0, 1, 2, 3, 4, 5]]
#print(liste_adj(liens_rezo))



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


# Fonction de routage statique
# Entrée: appellant, appele: source et destination
# Sortie: chemin prédéfini ou liste vide si aucun chemin n'est défini
def routage_statique(appellant, appele):
    chemin = []
    # Chemins prédéfinis
    if appellant == 0 and appele == 1:  # U1 à U2
        chemin = [0, 3, 1]  # CA1 -> CTS1 -> CA2
    elif appellant == 0 and appele == 2:  # U1 à U3
        chemin = [0, 4, 2]  # CA1 -> CTS2 -> CA3
    elif appellant == 1 and appele == 2:  # U2 à U3
        chemin = [1, 3, 2]  # CA2 -> CTS1 -> CA3
    elif appellant == 1 and appele == 0:  # U2 à U1
        chemin = [1, 3, 0]  # CA2 -> CTS1 -> CA1
    elif appellant == 2 and appele == 0:  # U3 à U1
        chemin = [2, 4, 0]  # CA3 -> CTS2 -> CA1
    elif appellant == 2 and appele == 1:  # U3 à U2
        chemin = [2, 3, 1]  # CA3 -> CTS1 -> CA2

    # Vérification des capacités
    for i in range(len(chemin) - 1):
        if capacites_stat[chemin[i]][chemin[i + 1]] <= 0:  # Si une capacité est nulle
            return []

    return chemin
    
# Algorithme de routage par partage de charge
# Entrée: liste_adj: liste des noeuds adjacents
#         appellant: noeud source
#         appele: noeud destination
# Sortie: chemin choisi ou liste vide si aucun chemin possible

def partage_charge(liste_adj, appellant, appele):
    chemins_p = trouver_chemins(liste_adj, appellant, appele)
    meilleur_chemin = []
    charge_min = float('inf')

    # Parcourir tous les chemins possibles
    for chemin in chemins_p:
        charge_chemin = min(
            [capacites_par[chemin[i]][chemin[i + 1]] for i in range(len(chemin) - 1)]
        )
        
        # Sélectionner le chemin avec la charge maximale (priorité au moins chargé)
        if charge_chemin < charge_min and charge_chemin > 0:
            charge_min = charge_chemin
            meilleur_chemin = chemin

    return meilleur_chemin if charge_min > 0 else []



# Fonction de routage adaptatif
# Entrée: liste_adj: liste des noeuds adjacents
#        appelant, appele: source et destination
#        capacites: matrice des capacités
# Sortie: chemin optimal ou vide si aucun chemin

def routage_adaptatif(liste_adj, appellant, appele):
    chemins_p = trouver_chemins(liste_adj, appellant, appele)

    meilleur_chemin = []
    capacite_max = 0

    for chemin in chemins_p:
        capacite_chemin = min(
            [capacites_adapt[chemin[i]][chemin[i+1]] for i in range(len(chemin)-1)]
        )

        if capacite_chemin > capacite_max:
            capacite_max = capacite_chemin
            meilleur_chemin = chemin

    return meilleur_chemin if capacite_max > 0 else []

# Mise à jour des capacités des liens après allocation ou libération

def maj_capacites(chemin, capacites, variation):
    for i in range(len(chemin)-1):
        capacites[chemin[i]][chemin[i+1]] += variation
        capacites[chemin[i+1]][chemin[i]] += variation
        
        
# Fonction qui génère des appels aléatoires
# Entrée: nb_appels: nombre d'appels à générer
#         n: nombre de composants dans le réseau
# Sortie: appels: liste des appels générés
def gene_appel(nb_appels, n):
    appels = []

    for _ in range(nb_appels):
        source = random.randint(0, n-1)  # Choisir une source aléatoire
        destination = random.randint(0, n-1)  # Choisir une destination aléatoire
        # Éviter que la source et la destination soient identiques
        while destination == source:
            destination = random.randint(0, n-1)

        duree = random.uniform(1, 5)  # Durée aléatoire entre 1 et 5 minutes
        appel = [source, destination, duree]
        appels.append(appel)

    return appels

# Simulation des trois routages et comparaison

def simulation(nb_appels, liste_adj):
    rejets_stat, rejets_par_charge, rejets_dyn = 0, 0, 0
    appels_stat, appels_par_charge, appels_dyn = [], [], []

    appels_min = int(nb_appels/60)

    # Variables pour stocker les temps de calcul
    temps_stat, temps_par_charge, temps_dyn = 0, 0, 0

    for min in range(60):
        generee = gene_appel(appels_min, 3)
        for appel in generee:
            source, destination, duree = appel

            # Routage statique
            start_time = time.time()  # Début du chronométrage
            chemin_stat = routage_statique(source, destination)
            temps_stat += time.time() - start_time  # Temps écoulé

            if chemin_stat:
                maj_capacites(chemin_stat, capacites_stat, -1)
                appels_stat.append((chemin_stat, duree))
            else:
                rejets_stat += 1

            # Routage par partage de charge
            start_time = time.time()
            chemin_par_charge = partage_charge(liste_adj, source, destination)
            temps_par_charge += time.time() - start_time

            if chemin_par_charge:
                maj_capacites(chemin_par_charge, capacites_par, -1)
                appels_par_charge.append((chemin_par_charge, duree))
            else:
                rejets_par_charge += 1

            # Routage adaptatif/dynamique
            start_time = time.time()
            chemin_dyn = routage_adaptatif(liste_adj, source, destination)
            temps_dyn += time.time() - start_time

            if chemin_dyn:
                maj_capacites(chemin_dyn, capacites_adapt, -1)
                appels_dyn.append((chemin_dyn, duree))
            else:
                rejets_dyn += 1


        for i in range(len(appels_stat) - 1, -1, -1):
            chemin, duree = appels_stat[i]
            duree -= 1
            if duree <= 0:
                maj_capacites(chemin, capacites_stat, 1)
                appels_stat.pop(i)
            else:
                appels_stat[i] = (chemin, duree)

        # Mise à jour des durées et libération des appels terminés
        for i in range(len(appels_par_charge) - 1, -1, -1):  # Parcourir à l'envers pour éviter les problèmes de modification en place
            chemin, duree = appels_par_charge[i]
            duree -= 1
            if duree <= 0:
                maj_capacites(chemin, capacites_par, 1)
                appels_par_charge.pop(i) 
            else:
                appels_par_charge[i] = (chemin, duree)


        for i in range(len(appels_dyn) - 1, -1, -1):
            chemin, duree = appels_dyn[i]
            duree -= 1
            if duree <= 0:
                maj_capacites(chemin, capacites_adapt, 1)
                appels_dyn.pop(i)
            else:
                appels_dyn[i] = (chemin, duree)

# Retourne les rejets et les temps de calcul
    return rejets_stat/nb_appels, rejets_par_charge/nb_appels, rejets_dyn/nb_appels, temps_stat, temps_par_charge, temps_dyn


""" # Lancer la simulation et afficher les résultats
nb_appels = 5000
rejets_stat, rejets_par_charge, rejets_dyn, temps_stat, temps_par_charge, temps_dyn = simulation(nb_appels, liste_adj)

print(f"Rejets Statique: {rejets_stat}, Temps Statique: {temps_stat:.6f} secondes")
print(f"Rejets Partage de Charge: {rejets_par_charge}, Temps Partage de Charge: {temps_par_charge:.6f} secondes")
print(f"Rejets Adaptatif: {rejets_dyn}, Temps Adaptatif: {temps_dyn:.6f} secondes")
 """





 # Simulation pour beaucoup de valeurs de nb_appels:
nb = [200*(i+1) for i in range(50)]
liste_stat = []
liste_par_charge = []
liste_dynamique = []

duree_stat = []
duree_par_charge = []
duree_dynamique = []

for i in nb:

    # Réinitialisation des Matrices de capacité
    capacites_stat = [[0, 10, 0, 100, 100],
                [10, 0, 10, 100, 100],
                [0, 10, 0, 100, 100],
                [100, 100, 100, 0, 1000],
                [100, 100, 100, 1000, 0]]
                
    capacites_par = [[0, 10, 0, 100, 100],
                [10, 0, 10, 100, 100],
                [0, 10, 0, 100, 100],
                [100, 100, 100, 0, 1000],
                [100, 100, 100, 1000, 0]]
                
    capacites_adapt = [[0, 10, 0, 100, 100],
                [10, 0, 10, 100, 100],
                [0, 10, 0, 100, 100],
                [100, 100, 100, 0, 1000],
                [100, 100, 100, 1000, 0]]
                

    rejets_stat, rejets_par_charge, rejets_dyn, temps_stat, temps_par_charge, temps_dyn = simulation(i, liste_adj)
    # Chance de rejet
    liste_stat.append(rejets_stat)
    liste_par_charge.append(rejets_par_charge)
    liste_dynamique.append(rejets_dyn)

    # Durée de calcul
    duree_stat.append(temps_stat)
    duree_par_charge.append(temps_par_charge)
    duree_dynamique.append(temps_dyn)



# Affichage des résultats
# Petit soucis avec l'afflchage des graphiques
# ils ne restent pas constamment, rencontrant une erreur critique.
# Cependant, le temps où ils restent affichés est suffisant pour voir les résultats ou de prendre des captures d'écran


plt.plot(nb, liste_stat)
plt.plot(nb, liste_par_charge)
plt.plot(nb, liste_dynamique)

plt.legend(["Statique", "Partage de charge", "Adaptatif"])
plt.xlabel("Nombre d'appels")
plt.ylabel("Taux de rejet")
plt.title("Taux de rejet en fonction du nombre d'appels")
plt.show()


""" 
plt.plot(nb, duree_stat)
plt.plot(nb, duree_par_charge)
plt.plot(nb, duree_dynamique)

plt.legend(["Statique", "Partage de charge", "Adaptatif"])
plt.xlabel("Nombre d'appels")
plt.ylabel("Durée de calculs")
plt.title("Temps d'execution en fonction du nombre d'appels")
plt.show()  """