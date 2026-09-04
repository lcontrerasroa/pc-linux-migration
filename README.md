# Migration Windows → Linux — ASUS ROG Strix GL10DH

Projet de préparation au passage sous Linux : sauvegarde des données essentielles,
inventaire des logiciels et de leurs équivalents Linux, choix de la distribution
adaptée au matériel.

- **Machine** : ASUS ROG Strix GL10DH_GL10DH (tour de bureau)
- **Objectif** : effacement complet du SSD NVMe (actuellement Windows 11) → **Fedora KDE 42**
- **Données à préserver** : Téléchargements (2 emplacements), Documents, Images, Bureau,
  **`Desktop\Adrien` (priorité absolue)**, `iCloudDrive`
- **Ne pas conserver** : jeux Steam, logiciels Windows non compatibles Linux
- **Cible de sauvegarde** : disque externe USB WD My Passport (`D:`, 291,9 Go libres)
- **Disque `E:` (Toshiba 1 To)** : reste en place, protégé en ne le cochant pas dans l'installateur
- **Date de préparation** : 2026-09-04

## Documents du projet

| Fichier | Contenu |
|---|---|
| [`01-plan-backup.md`](01-plan-backup.md) | Quoi sauvegarder, d'où, vers où, procédure pas à pas, sécurité des dossiers synchronisés (Google Drive, Nextcloud, iCloud) |
| [`02-inventaire-materiel.md`](02-inventaire-materiel.md) | Inventaire matériel complet relevé sur la machine + points sensibles pour les pilotes Linux |
| [`03-logiciels-equivalents-linux.md`](03-logiciels-equivalents-linux.md) | Liste des logiciels installés, classés, avec disponibilité Linux ou équivalent |
| [`04-choix-distribution-linux.md`](04-choix-distribution-linux.md) | Comparatif des distributions pour ce matériel précis + recommandation |
| [`05-checklist-execution.md`](05-checklist-execution.md) | Checklist chronologique : avant / pendant / après l'installation |
| [`scripts/backup.ps1`](scripts/backup.ps1) | Script PowerShell `robocopy` de sauvegarde (non destructif) |
| [`scripts/watch-backup.ps1`](scripts/watch-backup.ps1) | Barre de progression à lancer dans sa propre fenêtre PowerShell (lecture seule) |
| [`scripts/inventaire-post-install.md`](scripts/inventaire-post-install.md) | Commandes de vérification à lancer sous Linux après installation |

## État d'avancement

- [x] Inventaire matériel
- [x] Inventaire logiciel
- [x] Mesure des volumes à sauvegarder
- [x] Choix de la distribution
- [ ] Sauvegarde effectuée et vérifiée
- [ ] Dossiers cloud sécurisés (comptes déconnectés, copies vérifiées en ligne)
- [ ] Clé USB d'installation créée
- [ ] Installation Linux
- [ ] Restauration des données
- [ ] Réinstallation des logiciels

## Synchronisation avec Claude Code web

✅ **Publié** : `https://github.com/lcontrerasroa/pc-linux-migration.git`
(privé ; `main` suit `origin/main`, à jour au dernier commit).

Le dépôt apparaît sur [claude.ai/code](https://claude.ai/code) — on peut y lancer une
session cloud.

- **Ce terminal n'a pas les identifiants GitHub** : les commits que je fais en local
  restent locaux tant que **tu ne cliques pas `Push origin`** dans GitHub Desktop.
- Dans l'autre sens, après une session cloud : `Pull origin` dans GitHub Desktop pour
  récupérer les changements sur le PC.
- Reste à faire : supprimer l'ancien dépôt vide **`backup-pc`** sur github.com
  (`Settings` → bas de page → `Delete this repository`).

> Rappel : depuis 2021 GitHub refuse le mot de passe du compte pour Git — il faut la
> connexion navigateur (OAuth) de GitHub Desktop, ou un jeton d'accès personnel (PAT).
