# Drive Safe

## Université Côte d'Azur - EMSI

## MIAGE IA2 - 2025-2026

## Projet de création d'entreprise

Drive Safe est un projet de création d'entreprise consacré à la prévention de la fatigue au volant. Le prototype final est une application mobile Flutter qui utilise la caméra frontale d'un téléphone Android pour détecter des signaux compatibles avec une baisse de vigilance : yeux fermés, bâillements répétés, inclinaison de la tête et chute vers l'avant.

L'objectif est de proposer une solution logicielle simple, accessible et respectueuse de la confidentialité, sans boîtier propriétaire et sans stockage vidéo.

---

## Équipe

L'équipe fondatrice est composée de trois futurs ingénieurs polyvalents : Haitam OUAKHAIR, Wissal MOUJANNI et Douaa EL FANTROUSSI. Nous sommes issus du même parcours : lauréats EMSI en Ingénierie Informatique et Réseaux, actuellement en double diplomation MIAGE - IA appliquée à l'Université Côte d'Azur.

Le projet a été mené avec une organisation transversale : chaque membre a contribué à la partie technique, à la réflexion business et à la préparation des livrables. Une répartition principale des responsabilités a néanmoins été définie afin de structurer le travail.

| Membre | Responsabilité principale | Tâches confiées |
| --- | --- | --- |
| Wissal MOUJANNI | Détection fatigue, logique IA mobile et volet écologique | Intégration de Google ML Kit Face Mesh dans l'écran de surveillance, traitement du flux caméra, calcul EAR/MAR/angle de tête/chute vers l'avant, calibration, seuils, score de fatigue, alarme sonore, vibration, sauvegarde des résultats de session, modèle d'affaires responsable et partie écologie. |
| Haitam OUAKHAIR | Expérience utilisateur, Firebase et volet financier | Développement des écrans d'authentification, login/register, intégration Firebase Auth, gestion du profil utilisateur, participation à Firestore, tests du parcours connecté, construction du chiffre d'affaires 2027-2029, investissement initial, compte de résultat, plan de financement, trésorerie et pricing B2C/B2B. |
| Douaa EL FANTROUSSI | Conception fonctionnelle, parcours utilisateur, marché et concurrence | Conception du parcours utilisateur, mode invité, inscription, connexion, historique, réalisation des diagrammes use case, pipeline technique et stack technique, contribution aux écrans Accueil/Historique/détail de session, tests fonctionnels, analyse B2C/B2B, segmentation, concurrence, Business Model Canvas, positionnement privacy-first et communication. |

---

## Projet

Drive Safe est une application mobile de monitoring de vigilance conducteur.

Le fonctionnement du POC est le suivant :

1. La caméra frontale capture le visage du conducteur.
2. Google ML Kit Face Mesh détecte les points du visage.
3. L'application calcule des indicateurs comportementaux : EAR, MAR, angle de tête, chute vers l'avant.
4. Une calibration initiale adapte les seuils à l'utilisateur.
5. Un score de fatigue est calculé en temps réel.
6. Si un risque est détecté, l'application déclenche une alerte sonore et une vibration.
7. La session est sauvegardée dans l'historique local et, si l'utilisateur est connecté, dans Firestore.

Aucun modèle de machine learning n'a été entraîné par l'équipe. Le POC utilise Google ML Kit Face Mesh, un modèle pré-entraîné. La valeur du projet vient de l'intégration mobile, du traitement temps réel, de la calibration, des seuils de décision, des alertes, de l'historique et de l'expérience utilisateur.

---

## Plan du repository

```text
Drive_Safe_GitHub_Final/
  README.md
  application/
    drive_safe_mobile/
      lib/                         Code Dart de l'application mobile
      android/                     Projet Android Flutter
      assets/                      Ressources de l'application, dont l'alarme sonore
      test/                        Tests Flutter
      pubspec.yaml                 Dépendances et configuration Flutter
  conception/
    USE CASE drive safe.png        Diagramme de cas d'utilisation UML
    diagramme de flux.png          Pipeline fonctionnel et technique du POC
    technologie stack.png          Stack technique utilisée
  livrables/
    business_plan/
      Business Plan Drive Safe.docx
      Business Plan Drive Safe.pdf
      annexes/
        annexe_1_previsions_financieres/
          prevision financiere.xlsx
        annexe_4_business_model_et_ecologie/
          business_model_canvas_drive_safe.png
          modele_affaires_responsable_ecologie.pdf
          modele_affaires_responsable_ecologie.jpg
  POC et  Video Presentation/
    POC DRIVE SAFE.mp4             Vidéo courte de démonstration du POC
  premier_livrable/
    EMSI 1 ER RV ...               Premier livrable de conception transmis en début de projet
```

La vidéo complète de présentation est disponible via YouTube car le fichier source dépasse la limite standard de GitHub pour un dépôt classique.

---

## Technologies utilisées

| Domaine | Technologie |
| --- | --- |
| IDE | Visual Studio Code |
| Dépôt et versioning | GitHub |
| Langage principal | Dart |
| Framework mobile | Flutter |
| Caméra | Plugin `camera` |
| IA pré-entraînée | Google ML Kit Face Mesh |
| Métriques métier | EAR, MAR, angle de tête, calibration, score de fatigue |
| Alertes | `audioplayers`, `HapticFeedback` |
| Stockage local | `shared_preferences` |
| Authentification | Firebase Auth |
| Base de données cloud | Cloud Firestore |
| Plateforme cible | Android |

---

## Installation du POC mobile

Pré-requis :

- Flutter SDK installé.
- Android Studio ou Android SDK installé.
- Un téléphone Android ou un émulateur avec caméra.
- Un projet Firebase configuré si l'on souhaite tester la connexion et la synchronisation cloud.

Commandes :

```powershell
cd application/drive_safe_mobile
flutter pub get
```

---

## Lancement du POC mobile

```powershell
cd application/drive_safe_mobile
flutter run
```

Pour lancer sur Android :

```powershell
flutter run -d android
```

---

## Vérification du code

```powershell
cd application/drive_safe_mobile
flutter analyze
flutter test
```

---

## Configuration Firebase

Firebase est déjà configuré dans le POC Android fourni. Le fichier `google-services.json` est présent dans :

```text
application/drive_safe_mobile/android/app/google-services.json
```

Il relie l'application au projet Firebase utilisé pour le POC : `drive-safe-5ac8d`.

Firebase est utilisé pour l'authentification, le profil utilisateur et la sauvegarde optionnelle des statistiques de session dans Cloud Firestore. L'utilisateur final n'a rien à configurer.

Les données cloud sont organisées ainsi :

```text
users/{uid}/sessions/{sessionId}
users/{uid}/meta/profile
```

Firebase ne stocke ni vidéo, ni image caméra, ni empreinte faciale. Si le projet est cloné pour être relié à un autre espace Firebase, il suffit de remplacer le fichier `google-services.json` par celui du nouveau projet Firebase.

---

## Livrables

| Livrable | Emplacement |
| --- | --- |
| POC mobile Flutter | `application/drive_safe_mobile/` |
| Business plan final Word | `livrables/business_plan/Business Plan Drive Safe.docx` |
| Business plan final PDF | `livrables/business_plan/Business Plan Drive Safe.pdf` |
| Prévisions financières | `livrables/business_plan/annexes/annexe_1_previsions_financieres/prevision financiere.xlsx` |
| Business Model Canvas | `livrables/business_plan/annexes/annexe_4_business_model_et_ecologie/business_model_canvas_drive_safe.png` |
| Modèle d'affaires responsable | `livrables/business_plan/annexes/annexe_4_business_model_et_ecologie/` |
| Diagrammes de conception | `conception/` |
| Premier livrable | `premier_livrable/` |
| Vidéo POC | `POC et  Video Presentation/POC DRIVE SAFE.mp4` |

Vidéos en ligne :

- Présentation finale : https://www.youtube.com/watch?v=48DpSDv34LM
- Démonstration POC : https://youtu.be/KLhirXag-4g

---

## Points forts du POC

- Application mobile Flutter fonctionnelle.
- Détection du visage en temps réel.
- Utilisation d'un modèle IA pré-entraîné : Google ML Kit Face Mesh.
- Calcul de métriques explicables : EAR, MAR, angle de tête, chute vers l'avant.
- Calibration initiale personnalisée.
- Score de fatigue de 0 à 100.
- Alerte sonore et vibration.
- Mode invité disponible.
- Connexion utilisateur avec Firebase Auth.
- Historique de session local et synchronisation optionnelle avec Firestore.
- Confidentialité : aucune vidéo stockée.

---

## Axes d'amélioration et perspectives

- Tester le POC sur davantage de situations réelles : luminosité, lunettes, position du téléphone, trajets longs.
- Valider les seuils sur un panel plus large d'utilisateurs.
- Ajouter un tableau de bord B2B pour les flottes.
- Ajouter des exports d'historique et des statistiques avancées.
- Renforcer les tests terrain avant une commercialisation.
- Préparer un package Android avec un identifiant applicatif final.

---

## Confidentialité

Drive Safe suit une logique privacy-first :

- Les images caméra sont traitées en direct.
- Aucune vidéo n'est stockée.
- Les landmarks faciaux ne sont pas sauvegardés.
- Les données conservées sont des statistiques de session.
- La synchronisation cloud est optionnelle et liée à l'utilisateur connecté.

---

## Statut du projet

Le POC mobile est fonctionnel et présente les fonctionnalités principales attendues : détection temps réel, calibration, score de fatigue, alerte, mode invité, connexion utilisateur et historique de session.

Le projet reste un prototype. Il ne remplace pas la responsabilité du conducteur ni les dispositifs de sécurité homologués du véhicule.
