= ATM



Obj de l'ATM : pousser intégration des services dans le réseau, conçue pour transporter des données, voix, vidéo sur 1 mm ligne de communication.
RNIS-LB : Réseau Numérique à Intégration de Services Large Bande permets de véhiculer ce qu’on veut

On va utiliser pls réseaux de cœur : données, voix, etc.

Cela va créer des problèmes: 

Il y a des besoins variés, d'où l'utilisation de technologies différentes.
- Et chaque technologies aura des besoins différents en terme de QoS.

exemple: vidéo doit avoir haut débit + peu d'erreurs, mais peut avoir un délai. Voix peut avoir quelques erreurs, petit débit mais doit avoir faible délai.
autres possibilités: virement banquaire, visio-conférence, télétravail, jeux vidéos etc.

donc ATM:
permettre l'intégration d'apps variés sur 1 meme réseau:
       - voix, données, ...

Garantir un niv de QoS aux apps:
       - débit, délai, pertes, gigues, ...

Utiliser des infrastructures de communs:
       - fibre optique, cuivre, ...

Parcours différentes echelles:
        LAN, WLAN, ...

= Bases de l'ATM

Asyncronous Transfer Mode:
- Communication en mode de transfert asynchrone
- par opposition à STM qui était une évol de PDH

fondé sur la notion de cellule de taille *constante*:
- 53 octets: 48 octets de données + 5 octets d'en-tête
- Donc si y'a moins de données, ça reste 53o.

Connecté:
- Signalisation d'établissement de circuits virtuels
- Mécanismes de QoS

Peu de controles:
- Abs de controle d'erreur
- Abs de controle de flux
- Prévention de congestion par contrat

= Les Connections ATM

2 types de circuits virtuels:
- Virtual Path Connection (VPC) 
- Virtual Channel Connection (VCC)
--  VxI: Identifiant

Cannaux virtuels permanents:
ils sont faits à la main.


= Établissement des Circuits Virtuels
- établissement à l'interface usager/réseau
- négociation des paramètres du trafic + QoS


= Sous-couches PMD:
celulles peuvent être encapsulées dans des trames de la couche physique.
