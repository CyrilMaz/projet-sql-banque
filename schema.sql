CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    date_inscription DATE NOT NULL
);

CREATE TABLE agences (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    adresse VARCHAR(200) NOT NULL,
    agence_parente_id INT REFERENCES agences(id)
);

CREATE TABLE comptes (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(id),
    agence_id INT NOT NULL REFERENCES agences(id),
    type_compte VARCHAR(20) NOT NULL
        CHECK (type_compte IN ('courant', 'epargne')),
    solde NUMERIC(12,2) NOT NULL DEFAULT 0,
    date_ouverture DATE NOT NULL
);

CREATE TABLE virements (
    id SERIAL PRIMARY KEY,
    compte_source_id INT NOT NULL REFERENCES comptes(id),
    compte_destination_id INT NOT NULL REFERENCES comptes(id),
    montant NUMERIC(12,2) NOT NULL CHECK (montant > 0),
    date_virement DATE NOT NULL,
    statut VARCHAR(20) NOT NULL
        CHECK (statut IN ('en_attente', 'effectue', 'refuse')),
    CHECK (compte_source_id <> compte_destination_id)
);