1) Ajuster le numéro de version dans les fichiers
    grep -lR $ancienne_version . | xargs vim -p
    git commit -va

TODO : créer une branche release pour ça ?

2) Repartir d’un clone neuf
    git clone . release
    cd release
    git remote add github git@github.com:DraWallPlotter/ConVector

Cela permet de s’assurer que les résultats obtenus ne dépendent pas de fichiers
untracked ou ignorés. C’est plus rapide et moins sujet à erreurs que d’essayer
de nettoyer le dépôt courant.

3) Merger puis supprimer toutes les branches souhaitées dans master :
    git merge -m "Release $nouvelle_version" --log --no-ff branche branche2
    # Résoudre les éventuels conflits
    git branch -d branche branche2

Ne *rien* pusher pour l’instant. Ne pas faire de checkout, de commit...
En fait, éviter quasiment toutes les commandes git.

4) Générer la jar
    make jar
    make clean

Afin de s’assurer que l’on teste exactement ce qui est livré, il est important
d’exécuter les tests à partir de la jar, et non à partir des .class. Le clean
permet de s’assurer de cela.

5) Tester
    # TODO : détailler cette section

6) Si l’un des tests révèle un défaut bloquant :
* Supprimer le dépôt release
* Effectuer la correction dans la branche appropriée (pas master)
* Reprendre à l’étape 2.

7) Si tous les tests sont bons :
    git tag "v$nouvelle_version"
    git push --prune --tags master
    mv convector.jar convector-"$nouvelle_version".jar
    # Créer la release sur GitHub
    ???
    Profit!
