-- Q1 : Quels sont les comptes les mieux dotés dans chaque agence ?

SELECT
    agence_id,
    id,
    solde,
    RANK() OVER (
        PARTITION BY agence_id
        ORDER BY solde DESC
    ) AS rang
FROM comptes;


-- Q2 : Quel compte possède le solde le plus élevé par agence ?

WITH classement AS (
    SELECT
        agence_id,
        id,
        solde,
        ROW_NUMBER() OVER (
            PARTITION BY agence_id
            ORDER BY solde DESC, id
        ) AS rang
    FROM comptes
)
SELECT agence_id, id, solde
FROM classement
WHERE rang = 1
ORDER BY agence_id;