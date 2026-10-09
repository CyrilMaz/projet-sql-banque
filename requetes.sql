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


-- Q3 : Quel est le montant cumulé des virements effectués par mois ?

WITH virements_mensuels AS (
    SELECT
        DATE_TRUNC('month', date_virement)::date AS mois,
        SUM(montant) AS total_mois
    FROM virements
    WHERE statut = 'effectue'
    GROUP BY 1
)
SELECT
    mois,
    total_mois,
    SUM(total_mois) OVER (ORDER BY mois) AS cumul
FROM virements_mensuels
ORDER BY mois;


-- Q4 : Comment évolue le montant des virements d'un mois à l'autre ?

WITH virements_mensuels AS (
    SELECT
        DATE_TRUNC('month', date_virement)::date AS mois,
        SUM(montant) AS total_mois
    FROM virements
    WHERE statut = 'effectue'
    GROUP BY 1
)
SELECT
    mois,
    total_mois,
    LAG(total_mois) OVER (ORDER BY mois) AS mois_precedent,
    ROUND(
        100.0 * (total_mois - LAG(total_mois) OVER (ORDER BY mois))
        / NULLIF(LAG(total_mois) OVER (ORDER BY mois), 0),
        2
    ) AS evolution_pct
FROM virements_mensuels
ORDER BY mois;



-- Q5 : Quelle part du solde total représente chaque compte ?

SELECT
    id,
    client_id,
    solde,
    ROUND(
        100.0 * solde / SUM(solde) OVER (),
        2
    ) AS part_pct
FROM comptes
ORDER BY part_pct DESC;



-- Q6 : Quelle est la moyenne des 3 derniers virements effectués ?

SELECT
    id,
    date_virement,
    montant,
    ROUND(
        AVG(montant) OVER (
            ORDER BY date_virement, id
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moyenne_mobile
FROM virements
WHERE statut = 'effectue'
ORDER BY date_virement, id;