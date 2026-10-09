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