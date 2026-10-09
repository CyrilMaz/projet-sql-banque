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



-- Q9 : Quelle est la hiérarchie des agences bancaires ?

WITH RECURSIVE hierarchie AS (
    SELECT
        id,
        nom,
        agence_parente_id,
        0 AS niveau,
        nom::text AS chemin
    FROM agences
    WHERE agence_parente_id IS NULL

    UNION ALL

    SELECT
        a.id,
        a.nom,
        a.agence_parente_id,
        h.niveau + 1,
        h.chemin || ' > ' || a.nom
    FROM agences a
    JOIN hierarchie h ON a.agence_parente_id = h.id
)
SELECT id, nom, niveau, chemin
FROM hierarchie
ORDER BY chemin;



-- Q10 : Quels jours n'ont eu aucun virement effectué ?

SELECT
    j.jour::date AS jour,
    COUNT(v.id) AS nombre_virements,
    COALESCE(SUM(v.montant), 0) AS montant_total
FROM generate_series(
    DATE '2026-07-01',
    DATE '2026-09-30',
    INTERVAL '1 day'
) AS j(jour)
LEFT JOIN virements v
    ON v.date_virement = j.jour::date
    AND v.statut = 'effectue'
GROUP BY j.jour
HAVING COUNT(v.id) = 0
ORDER BY j.jour;



-- Q11 : Quel est le montant des virements par agence et par statut ?

SELECT
    CASE
        WHEN GROUPING(c.agence_id) = 1 THEN 'Toutes les agences'
        ELSE c.agence_id::text
    END AS agence,
    CASE
        WHEN GROUPING(v.statut) = 1 THEN 'Tous les statuts'
        ELSE v.statut
    END AS statut,
    COUNT(*) AS nombre_virements,
    SUM(v.montant) AS montant_total
FROM virements v
JOIN comptes c ON v.compte_source_id = c.id
GROUP BY ROLLUP(c.agence_id, v.statut)
ORDER BY c.agence_id NULLS LAST, v.statut NULLS LAST;



-- Q12 : Quelle est la moyenne et la médiane des virements effectués ?

SELECT
    ROUND(AVG(montant), 2) AS moyenne,
    ROUND(
        percentile_cont(0.5) WITHIN GROUP (ORDER BY montant)::numeric,
        2
    ) AS mediane
FROM virements
WHERE statut = 'effectue';



-- Q13 : Quelles sont les performances de chaque agence ?

WITH activite_agences AS (
    SELECT
        c.agence_id,
        COUNT(v.id) AS nombre_virements,
        SUM(v.montant) AS montant_total
    FROM virements v
    JOIN comptes c ON v.compte_source_id = c.id
    WHERE v.statut = 'effectue'
    GROUP BY c.agence_id
)
SELECT
    agence_id,
    nombre_virements,
    montant_total,
    RANK() OVER (ORDER BY montant_total DESC) AS rang,
    ROUND(
        100.0 * montant_total / SUM(montant_total) OVER (),
        2
    ) AS part_pct
FROM activite_agences
ORDER BY rang;