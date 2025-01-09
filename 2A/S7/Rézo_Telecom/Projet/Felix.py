# Trouver tous les chemins entre deux sommets sans boucles
def trouver_chemins(graph, source, destination, chemin_actuel=[]):
    chemin_actuel = chemin_actuel + [source]  # Ajouter le nœud actuel au chemin
    if source == destination:  # Si on atteint le nœud de destination, retourner le chemin
        return [chemin_actuel]
    
    chemins = []  # Liste pour stocker les chemins
    for voisin in graph[source]:
        if voisin not in chemin_actuel:  # Éviter les boucles
            chemins += trouver_chemins(graph, voisin, destination, chemin_actuel)
    
    return chemins

# Exemple avec une matrice d'adjacence convertie en liste d'adjacence
liens_ex = [[0, 1, 0, 0],
            [1, 0, 1, 1],
            [0, 1, 0, 1],
            [0, 1, 1, 0]]

# Convertir la matrice d'adjacence en liste d'adjacence
def matrice_vers_liste_adj(liens_ex):
    return [[j for j in range(len(liens_ex[i])) if liens_ex[i][j] == 1] for i in range(len(liens_ex))]

liste_adj = matrice_vers_liste_adj(liens_ex)

# Trouver tous les chemins entre deux nœuds
source = 0
destination = 3
chemins = trouver_chemins(liste_adj, source, destination)

print(f"Tous les chemins de {source} à {destination} : {chemins}")
