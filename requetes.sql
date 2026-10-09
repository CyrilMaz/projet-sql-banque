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



-- Q7 : Quels comptes ont envoyé plus d'argent que la moyenne ?

WITH total_par_compte AS (
    SELECT
        compte_source_id AS compte_id,
        SUM(montant) AS total_envoye
    FROM virements
    WHERE statut = 'effectue'
    GROUP BY compte_source_id
),
moyenne AS (
    SELECT AVG(total_envoye) AS moyenne_envoyee
    FROM total_par_compte
)
SELECT
    t.compte_id,
    t.total_envoye,
    ROUND(m.moyenne_envoyee, 2) AS moyenne
FROM total_par_compte t
CROSS JOIN moyenne m
WHERE t.total_envoye > m.moyenne_envoyee
ORDER BY t.total_envoye DESC;




-- Q8 : Quelle part des virements effectués représente chaque agence ?

WITH total_par_agence AS (
    SELECT
        c.agence_id,
        SUM(v.montant) AS total_envoye
    FROM virements v
    JOIN comptes c ON v.compte_source_id = c.id
    WHERE v.statut = 'effectue'
    GROUP BY c.agence_id
),
parts_agences AS (
    SELECT
        agence_id,
        total_envoye,
        ROUND(
            100.0 * total_envoye / SUM(total_envoye) OVER (),
            2
        ) AS part_pct
    FROM total_par_agence
)
SELECT *
FROM parts_agences
ORDER BY total_envoye DESC;