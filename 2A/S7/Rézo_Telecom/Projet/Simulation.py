import simpy
import random

# Paramètres du réseau
CAPACITE_LIEN = 2  # Nombre maximal d'appels simultanés sur un lien
DUREE_APPEL_MIN = 1  # Durée minimale d'un appel
DUREE_APPEL_MAX = 5  # Durée maximale d'un appel
NB_APPELS = 10  # Nombre total d'appels à générer

# Définition des liens du réseau
class Lien:
    def __init__(self, env, capacite):
        self.ressource = simpy.Resource(env, capacity=capacite)
        self.utilisation = 0  # Pour suivre l'utilisation du lien

# Définition des appels pour le routage statique
class AppelStatique:
    def __init__(self, env, source, destination, liens, duree):
        self.env = env
        self.source = source
        self.destination = destination
        self.liens = liens
        self.duree = duree
        env.process(self.executer())

    def executer(self):
        chemin = self.trouver_chemin_statique()
        if chemin:
            print(f"[{self.env.now}] Appel statique de {self.source} à {self.destination} : chemin {chemin} trouvé.")

            reservations = []
            for lien in chemin:
                req = self.liens[lien].ressource.request()
                reservations.append(req)
                yield req
                self.liens[lien].utilisation += 1

            print(f"[{self.env.now}] Appel statique de {self.source} à {self.destination} établi.")

            yield self.env.timeout(self.duree)

            for lien, req in zip(chemin, reservations):
                self.liens[lien].ressource.release(req)
                self.liens[lien].utilisation -= 1

            print(f"[{self.env.now}] Appel statique de {self.source} à {self.destination} terminé.")
        else:
            print(f"[{self.env.now}] Appel statique de {self.source} à {self.destination} rejeté (pas de chemin disponible).")

    def trouver_chemin_statique(self):
        chemins = {
            ("CA1", "CA2"): ["CA1-CTS1", "CTS1-CA2"],
            ("CA1", "CA3"): ["CA1-CTS2", "CTS2-CA3"],
            ("CA2", "CA3"): ["CA2-CTS1", "CTS1-CA3"],
        }
        chemin = chemins.get((self.source, self.destination), [])
        if all(self.liens[lien].ressource.count < self.liens[lien].ressource.capacity for lien in chemin):
            return chemin
        return []

# Définition des appels pour le routage par partage de charge
class AppelPartage:
    def __init__(self, env, source, destination, liens, duree):
        self.env = env
        self.source = source
        self.destination = destination
        self.liens = liens
        self.duree = duree
        env.process(self.executer())

    def executer(self):
        chemin = self.trouver_chemin_partage()
        if chemin:
            print(f"[{self.env.now}] Appel partage de charge de {self.source} à {self.destination} : chemin {chemin} trouvé.")

            reservations = []
            for lien in chemin:
                req = self.liens[lien].ressource.request()
                reservations.append(req)
                yield req
                self.liens[lien].utilisation += 1

            print(f"[{self.env.now}] Appel partage de charge de {self.source} à {self.destination} établi.")

            yield self.env.timeout(self.duree)

            for lien, req in zip(chemin, reservations):
                self.liens[lien].ressource.release(req)
                self.liens[lien].utilisation -= 1

            print(f"[{self.env.now}] Appel partage de charge de {self.source} à {self.destination} terminé.")
        else:
            print(f"[{self.env.now}] Appel partage de charge de {self.source} à {self.destination} rejeté (pas de chemin disponible).")

    def trouver_chemin_partage(self):
        chemins = {
            ("CA1", "CA2"): ["CA1-CTS1", "CTS1-CA2"],
            ("CA1", "CA3"): ["CA1-CTS2", "CTS2-CA3"],
            ("CA2", "CA3"): ["CA2-CTS1", "CTS1-CA3"],
        }
        chemins_disponibles = [chemin for chemin in chemins.values() if all(
            self.liens[lien].ressource.count < self.liens[lien].ressource.capacity for lien in chemin
        )]
        if chemins_disponibles:
            return min(chemins_disponibles, key=lambda chemin: sum(self.liens[lien].ressource.count for lien in chemin))
        return []

# Définition des appels pour le routage adaptatif
class AppelAdaptatif:
    def __init__(self, env, source, destination, liens, duree):
        self.env = env
        self.source = source
        self.destination = destination
        self.liens = liens
        self.duree = duree
        env.process(self.executer())

    def executer(self):
        chemin = self.trouver_chemin_adaptatif()
        if chemin:
            print(f"[{self.env.now}] Appel adaptatif de {self.source} à {self.destination} : chemin {chemin} trouvé.")

            reservations = []
            for lien in chemin:
                req = self.liens[lien].ressource.request()
                reservations.append(req)
                yield req
                self.liens[lien].utilisation += 1

            print(f"[{self.env.now}] Appel adaptatif de {self.source} à {self.destination} établi.")

            yield self.env.timeout(self.duree)

            for lien, req in zip(chemin, reservations):
                self.liens[lien].ressource.release(req)
                self.liens[lien].utilisation -= 1

            print(f"[{self.env.now}] Appel adaptatif de {self.source} à {self.destination} terminé.")
        else:
            print(f"[{self.env.now}] Appel adaptatif de {self.source} à {self.destination} rejeté (pas de chemin disponible).")

    def trouver_chemin_adaptatif(self):
        chemins = {
            ("CA1", "CA2"): ["CA1-CTS1", "CTS1-CA2"],
            ("CA1", "CA3"): ["CA1-CTS2", "CTS2-CA3"],
            ("CA2", "CA3"): ["CA2-CTS1", "CTS1-CA3"],
        }
        chemins_disponibles = [chemin for chemin in chemins.values() if all(
            self.liens[lien].ressource.count < self.liens[lien].ressource.capacity for lien in chemin
        )]
        if chemins_disponibles:
            return max(chemins_disponibles, key=lambda chemin: min(self.liens[lien].ressource.capacity - self.liens[lien].ressource.count for lien in chemin))
        return []

# Initialisation de l'environnement SimPy
def simulation(env, nb_appels, mode):
    liens = {
        "CA1-CTS1": Lien(env, CAPACITE_LIEN),
        "CTS1-CA2": Lien(env, CAPACITE_LIEN),
        "CA1-CTS2": Lien(env, CAPACITE_LIEN),
        "CTS2-CA3": Lien(env, CAPACITE_LIEN),
        "CA2-CTS1": Lien(env, CAPACITE_LIEN),
        "CTS1-CA3": Lien(env, CAPACITE_LIEN),
    }

    sources = ["CA1", "CA2", "CA3"]
    destinations = ["CA1", "CA2", "CA3"]

    for _ in range(nb_appels):
        source = random.choice(sources)
        destination = random.choice(destinations)
        while source == destination:
            destination = random.choice(destinations)

        duree = random.randint(DUREE_APPEL_MIN, DUREE_APPEL_MAX)

        if mode == "statique":
            AppelStatique(env, source, destination, liens, duree)
        elif mode == "partage":
            AppelPartage(env, source, destination, liens, duree)
        elif mode == "adaptatif":
            AppelAdaptatif(env, source, destination, liens, duree)

    yield env.timeout(100)  # Durée totale de la simulation

# Simulation pour chaque mode
env = simpy.Environment()
print("--- Simulation Statique ---")
env.process(simulation(env, NB_APPELS, "statique"))
env.run()

env = simpy.Environment()
print("--- Simulation Partage de Charge ---")
env.process(simulation(env, NB_APPELS, "partage"))
env.run()

env = simpy.Environment()
print("--- Simulation Adaptative ---")
env.process(simulation(env, NB_APPELS, "adaptatif"))
env.run()
