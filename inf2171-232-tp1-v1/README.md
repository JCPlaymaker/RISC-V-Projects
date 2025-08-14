# INF2171-232 TP1

Vous devez réaliser deux fonctions pour manipuler des couleurs RGBA dans le ficheir `color.s`.

 * `color_add`: ajoute deux couleurs a + b
 * `color_sub`: soustrait deux couleurs a - b

Les couleurs a et b sont passés en argument dans les registres a0 et a1 respectivement, puis la fonction retourne le résultat dans a0.

Voici les spécifications:
 * L'opération doit se faire sur chaque composant de couleur séparément.
 * L'addition doit saturer à 0xFF (exemple: 0xEE + 0xEE = 0xFF)
 * La soustraction doit saturer à 0x00 (exemple: 0xAA - 0xEE = 0x00)

Le fichier `main.s` contient les tests pour fins de validation. Le programme doit être réalisé avec RARS 1.6. Pour exécuter le programme, il faut s'assurer d'activer l'option `Settings > Assemble all files in directory`. Pour exécuter le programme, il faut sélectionner le fichier `main.s` et ensuite compiler.

Vous pouvez exécuter les tests avec la commande `build.sh`, ou l'équivalent sur votre système d'exploitation.

Votre travail sera corrigé sur le système [Hopper](https://hopper.info.uqam.ca). Faire l'archive avec `makedist`, puis envoyer l'archive sur le serveur de correction. Votre note sera attribuée automatiquement. Vous pouvez soumettre votre travail plusieurs fois et la meilleure note sera conservée. D'autres détails et instructions pour l'utilisation de ce système seront fournis.

Barème de correction

 * Implémentation correcte de la fonction `color_add`: 50 points
 * Implémentation correcte de la fonction `color_sub`: 50 points
 * Total sur 100 points

Bon travail!

