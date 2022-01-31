# Weather App

C’est une application de prévisions météo, créée à l’aide de Flutter et Dart.
Le projet utilise l' API OpenWeatherMap pour récupérer une liste de villes et leurs données météorologiques respectives telles que la température minimale et maximale, l'état météorologique, la date, la vitesse, l’humidité et la pression.
Vous pouvez trouver les données météorologiques en direct de n’importe quelle ville que vous voulez savoir.

![d5639200-6666-44c1-a6bd-2abaf90fe513](https://user-images.githubusercontent.com/94973789/151840786-bf1fd088-8c37-4c25-bf3b-e306b4129efa.jpg)
![951eb1e7-9b6e-41c7-b657-f00cb63ac12a](https://user-images.githubusercontent.com/94973789/151840789-eeda2776-ed23-45d1-8971-cb6693f889be.jpg)



### Exigences 
  * Visual Studio Code
  * Android Studio 
  * Chrome - develop for the web
  * Configuration de Firebase dans votre propre compte
  * JDK ()
  * Android SDK 30

## Prérequis
Afin de pouvoir exécuter l'application sur votre poste, vous devez d'aborder installer les dépendances suivantes :
  * Flutter
  * Dart
  * Firebase
 
## Installation
#### Flutter
  1. Télécharger la version ici (https://docs.flutter.dev/get-started/install)
  2. Suivre les étapes d'installation en laissant les options par défaut.


## Exécution
- Télécharger le zip code et effectuer l'extraction
- Ouvrir un nouveau projet flutter dans Visual Studio Code (View -> Command Palette ->Flutter : New Project -> choisir un emplacement et un nom d’application)
- Copier du dossier github, le dossier < assets> ainsi que les fichiers qui se trouvent dans lib ( api, main, current, search et le dossier <models>) et les remplacer dans le nouveau projet créee 
- Vérifier l'existance des dépendances nécessaires du fichier <pubspec.yaml> 
- Ouvrir le fichier main.dart trouvé à la racine du référentiel cloné ( weather-app\lib\main.dart)
- Installer les packages nécessaires avec la commande: flutter pub get
- Configurer un emulator Android dans Android Studio, ou connecter un appareil Android physique qui a été configuré pour fonctionner en mode de débogage USB. 
- Exécuter le projet avec la commande :  run flutter


## Caractéristiques
  * Recherche météo par ville
  * Température actuelle, température max et min, et le ressenti
  * Température en Celsius, Kelvin et Fahrenheit
  * Prévisions météo à 7 jours
  * Icônes personnalisées pour chaque condition météo
  * Ressenti
  * Vitesse du vent
  * Humidité
  * Pression
  * Alerte en rouge quand il pleut dans une ville
  * Gestion compte utilisateur
  * Liste de villes enregistrées par l'utilisateur

 

