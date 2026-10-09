## Q1 — Classement des comptes par agence

La fonction RANK() permet de classer les comptes selon leur solde au sein de chaque agence.

Résultat : chaque agence possède 2 comptes. Le compte avec le solde le plus élevé obtient le rang 1.



## Q2 — Meilleur compte par agence

La CTE permet de calculer un classement avec ROW_NUMBER(), puis de sélectionner uniquement le premier compte de chaque agence.

Résultat : 15 comptes sont affichés, un par agence.



## Q3 — Cumul mensuel des virements

La fonction SUM() OVER (ORDER BY mois) permet de calculer le cumul des virements effectués au fil des mois.

Résultat : le montant cumulé augmente chaque mois en ajoutant les virements du mois au total précédent.



## Q4 — Évolution mensuelle des virements

La fonction LAG() permet de comparer le montant des virements effectués avec celui du mois précédent.

Résultat : l'évolution en pourcentage permet d'identifier les mois où l'activité bancaire augmente ou diminue.



## Q5 — Part de chaque compte dans le solde total

La fonction SUM() OVER () permet de calculer le solde total de tous les comptes sans regrouper les lignes.

Résultat : chaque compte affiche sa contribution en pourcentage au solde total de la banque.



## Q6 — Moyenne mobile des virements

La fonction AVG() OVER() avec ROWS BETWEEN permet de calculer la moyenne des 3 derniers virements effectués.

Résultat : cette moyenne permet de suivre l'évolution des montants des virements en réduisant les variations ponctuelles.



## Q7 — Comptes au-dessus de la moyenne des virements

La première CTE calcule le total des virements effectués par compte.
La deuxième CTE calcule la moyenne de ces totaux.

Résultat : la requête identifie les comptes qui envoient plus d'argent que la moyenne.



## Q8 — Répartition des virements par agence

La première CTE calcule le montant total des virements effectués par agence. La deuxième CTE calcule la part de chaque agence dans le total.

Résultat : l'agence 3 arrive en tête avec 2 167 € de virements, soit 8,79 % du total.



## Q9 — Hiérarchie des agences

La fonction WITH RECURSIVE permet de parcourir la hiérarchie des agences bancaires.

Résultat : le siège central est au niveau 0 et les 14 agences rattachées sont au niveau 1.

La colonne chemin permet de visualiser les relations entre les agences.



## Q10 — Jours sans activité bancaire

La fonction generate_series() génère toutes les dates de la période étudiée.

Le LEFT JOIN permet de conserver les jours sans virement effectué, et COALESCE() remplace les montants absents par 0.

Résultat : la requête affiche uniquement les jours où aucun virement n'a été effectué.




## Q11 — Rapport des virements avec sous-totaux

La fonction ROLLUP permet de calculer les montants des virements par agence et par statut, avec des sous-totaux et un total général.

GROUPING() permet de distinguer les sous-totaux des lignes normales.

Résultat : le rapport permet de comparer l'activité des agences et d'obtenir une vue globale des virements.



## Q12 — Comparaison de la moyenne et de la médiane

La fonction AVG() calcule la moyenne des virements, tandis que percentile_cont(0.5) calcule leur médiane.

Résultats :
- Moyenne : 267,86 €
- Médiane : 265,50 €

Les deux valeurs sont très proches, ce qui indique qu'elles représentent assez bien les montants des virements.

La médiane reste toutefois plus robuste face aux valeurs extrêmes, car elle est moins influencée par les virements exceptionnellement élevés.