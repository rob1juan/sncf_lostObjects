# Application SNCF Objets perdus en Flutter
Développé par JUAN Robin

## Table des matières
- [Introduction](#introduction)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Architecture](#architecture)
- [Choix d'implémentation](#choix-dimplémentation)

## Introduction
Ce projet est une application Flutter qui permet aux utilisateurs de consulter les objets trouvés récents signalés à la SNCF. L'application offre une interface simple pour rechercher des objets récents, afficher l'historique des recherches et consulter les détails de chaque objet.

## Installation
Pour exécuter ce projet, vous devez avoir Flutter installé sur votre machine. 

Suivez ces étapes pour commencer :

1. Cloner le dépôt :

```sh
git clone https://github.com/votre_nom/sncfflutter.git
cd sncfflutter
```

2. Installer les dépendances :

```sh
flutter pub get
```

3. Exécuter l'application :

```sh
flutter run
```

## Utilisation
1. **Lancer l'application** : Ouvrez l'application sur votre appareil ou émulateur.
2. **Rechercher des objets** : Utilisez l'onglet "Chercher" pour effectuer une recherche d'objets spécifiques.
3. **Voir les objets récents** : Accédez à l'onglet "Récent" pour voir les objets trouvés depuis votre dernière connexion.
4. **Consulter l'historique** : L'onglet "Historique" affiche vos recherches passées.
5. **Voir les détails** : Sélectionnez un objet pour voir plus de détails à son sujet.
## Architecture
Le projet suit une architecture modulaire pour maintenir l'organisation et la lisibilité du code. Voici un aperçu des principaux composants :

- lib : Contient le code source principal de l'application.
- models : Définit les modèles de données utilisés dans l'application.
- screens : Contient les principaux écrans de l'application.
    - recent.dart : Affiche les objets trouvés récemment.
    - search.dart : Permet de rechercher des objets spécifiques.
    - history.dart : Affiche l'historique des recherches.
- widgets : Contient des widgets réutilisables utilisés dans l'application.
- utils : Contient les utilitaires et les services, comme les appels API.
- main.dart : Le point d'entrée de l'application.

## Choix d'implémentation
### Gestion d'état
L'application utilise setState pour la gestion d'état simple. Ce choix a été fait pour sa simplicité dans le contexte de cette application. Pour une application plus complexe, un package comme Provider ou Bloc pourrait être envisagé.

### Appels API
Les appels API sont effectués à l'aide du package http. Les données sont récupérées depuis l'API SNCF pour afficher les objets trouvés récents.

### Stockage des données
L'application utilise SharedPreferences pour stocker la date de la dernière connexion, permettant de filtrer les objets trouvés depuis cette date.

### Interface Utilisateur
L'interface utilisateur est construite avec des widgets Flutter standard, offrant une navigation fluide entre les différents écrans grâce à un BottomNavigationBar personnalisé.