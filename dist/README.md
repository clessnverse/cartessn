# Installation du package cartessn

Ce répertoire contient une version compilée du package cartessn qui peut être installée localement, sans dépendre de GitHub ni des serveurs CRAN.

## Installation

### Option 1: Installation directe (recommandée)

```r
install.packages("chemin/vers/cartessn_0.1.0.tar.gz", repos = NULL, type = "source")
```

Remplacez "chemin/vers" par le chemin d'accès complet au fichier tar.gz.

### Option 2: Utilisation du script d'installation

```r
source("chemin/vers/install_local.R")
```

## Vérification de l'installation

Pour vérifier que l'installation a réussi, exécutez:

```r
library(cartessn)
```

Si aucune erreur n'apparaît, le package est correctement installé.

## Problèmes connus

Si vous rencontrez des problèmes d'encodage lors de l'installation, utilisez la version précompilée fournie ici plutôt que d'essayer d'installer depuis GitHub.
