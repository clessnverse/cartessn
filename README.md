# Package pour faire des cartes - CLESSN



## Dossier `data-raw`
Le dossier `data-raw` contient les scripts roulés en local qui permettent de préparer les données utilisées dans ce package comme les shapefiles. Les sous-dossiers à la racine du dossier `data-raw` font référence aux éditions de découpages des circonscriptions. Par exemple, le sous-dossier `data-raw/canada_2022` contient les scripts qui préparent les données du redécoupage électoral fédéral de 2022.

Les données intermédiaires qui ne sont pas nécessaires à l'utilisation du package sont stockées dans le dossier `data` à l'intérieur de `data-raw`. Ce dossier est exclus du package par le fichier `.gitignore` et peut entièrement généré grâce aux scripts dans `data-raw`.