## Q1 — Classement des comptes par agence

La fonction RANK() permet de classer les comptes selon leur solde au sein de chaque agence.

Résultat : chaque agence possède 2 comptes. Le compte avec le solde le plus élevé obtient le rang 1.



## Q2 — Meilleur compte par agence

La CTE permet de calculer un classement avec ROW_NUMBER(), puis de sélectionner uniquement le premier compte de chaque agence.

Résultat : 15 comptes sont affichés, un par agence.