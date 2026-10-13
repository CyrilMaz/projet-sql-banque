SELECT
    AVG(montant) AS moyenne,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY montant) AS mediane
FROM virements
WHERE statut = 'effectue';
