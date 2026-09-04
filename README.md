# Migration Windows → Linux — ASUS ROG Strix GL10DH

Projet de préparation au passage sous Linux : sauvegarde des données essentielles,
inventaire des logiciels et de leurs équivalents Linux, choix de la distribution
adaptée au matériel.

- **Machine** : ASUS ROG Strix GL10DH_GL10DH (tour de bureau)
- **Objectif** : effacement complet du SSD NVMe (actuellement Windows 11) → **Fedora KDE 44**
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
- [x] Sauvegarde effectuée et vérifiée
- [x] Dossiers cloud sécurisés (comptes déconnectés, copies vérifiées en ligne)
- [x] Clé USB d'installation créée (Fedora KDE 44, vérifiée par empreinte SHA-256)
- [ ] Installation Linux
- [ ] Restauration des données
- [ ] Réinstallation des logiciels

## Synchronisation

✅ **Publié** : `https://github.com/lcontrerasroa/pc-linux-migration.git` (privé).

Le dépôt apparaît sur [claude.ai/code](https://claude.ai/code) — on peut y lancer une
session cloud.

**Depuis le 2026-09-04, le clone de référence est sur le portable HP ZBook**, dans
`~/Documents/pc-linux-migration`, et `gh` y est authentifié : les commits partent
directement avec `git push`. C'est ce clone qui compte désormais, puisque le PC Windows
(ASUS ROG) est effacé et que son clone GitHub Desktop disparaît avec lui.

- Reste à faire : supprimer l'ancien dépôt vide **`backup-pc`** sur github.com
  (`Settings` → bas de page → `Delete this repository`).
