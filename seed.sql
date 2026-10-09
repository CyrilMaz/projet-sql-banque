-- Création du siège principal
INSERT INTO agences (nom, ville, adresse)
VALUES ('Siège central', 'Paris', '1 rue Principale');

-- Création de 14 agences rattachées au siège
INSERT INTO agences (nom, ville, adresse, agence_parente_id)
SELECT
    'Agence ' || n,
    'Ville ' || n,
    n || ' rue de la Banque',
    (SELECT id FROM agences WHERE nom = 'Siège central')
FROM generate_series(1, 14) AS n;

-- Génération de 15 clients fictifs
INSERT INTO clients (nom, prenom, email, date_inscription)
SELECT
    'Nom ' || n,
    'Prenom ' || n,
    'client' || n || '@example.com',
    DATE '2026-06-01' + (n - 1)
FROM generate_series(1, 15) AS n;

-- Génération de 30 comptes bancaires
INSERT INTO comptes (client_id, agence_id, type_compte, solde, date_ouverture)
SELECT
    1 + ((n - 1) % 15),
    1 + ((n - 1) % 15),
    CASE WHEN n % 2 = 0 THEN 'epargne' ELSE 'courant' END,
    1000 + n * 50,
    DATE '2026-06-01' + (n - 1)
FROM generate_series(1, 30) AS n;

-- Génération de 120 virements entre juillet et septembre 2026
INSERT INTO virements (compte_source_id, compte_destination_id, montant, date_virement, statut)
SELECT
    1 + ((n - 1) % 30),
    1 + (n % 30),
    10 + ((n * 37) % 500),
    DATE '2026-07-01' + ((n - 1) % 92),
    CASE
        WHEN n % 10 = 0 THEN 'refuse'
        WHEN n % 7 = 0 THEN 'en_attente'
        ELSE 'effectue'
    END
FROM generate_series(1, 120) AS n;