# projet-sql-banque

# Tables :

## table clients :
- `id` : identifiant unique du client.
- `nom` : nom du client.
- `prenom` : prénom du client.
- `email` : adresse e-mail.
- `date_inscription` : date d'arrivée du client dans la banque.

## table comptes
- `id` : identifiant unique du compte.
- `client_id`
- `agence_id` : agence qui gère le compte.
- `type_compte` : courant, épargne, etc.
- `solde` : argent disponible sur le compte.
- `date_ouverture` : date de création du compte.

## table virements
- `id` : identifiant unique du virement.
- `compte_source_id` : compte qui envoie l'argent.
- `compte_destination_id` : compte qui reçoit l'argent.
- `montant` : somme transférée.
- `date_virement` : date du transfert.
- `statut` : en attente, effectué ou refusé.

## table agences
- `id` : identifiant unique de l'agence.
- `nom` : nom de l'agence.
- `ville` : ville où se trouve l'agence.
- `adresse` : adresse de l'agence.
- `agence_parente_id` : identifiant de l'agence dont elle dépend.


## Relations entre les tables :
- `comptes.client_id` → `clients.id`
- `comptes.agence_id` → `agences.id`
- `virements.compte_source_id` → `comptes.id`
- `virements.compte_destination_id` → `comptes.id`
- `agences.agence_parente_id` → `agences.id`