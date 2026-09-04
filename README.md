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

Dépôt Git **local uniquement** pour l'instant (aucun remote configuré — l'ancien lien
vers `backup-pc` a été retiré).

**Pourquoi la connexion GitHub échoue** : depuis août 2021, GitHub **n'accepte plus le
mot de passe du compte** pour les opérations Git. Il faut soit un *jeton d'accès
personnel* (PAT), soit la connexion par navigateur (OAuth) — c'est ce que fait GitHub
Desktop.

**Marche à suivre :**

1. **GitHub Desktop** → `File` → `Options` → `Accounts` → `Sign out`, puis `Sign in` →
   **« Sign in using your browser »** → autoriser dans le navigateur (déjà connecté à
   github.com). Plus de mot de passe à taper dans Git.
2. `File` → `Add local repository…` → `C:\Users\cyber\github\pc-linux-migration`
3. Bouton **`Publish repository`** → nom **`pc-linux-migration`** → **cocher « Keep this
   code private »** → publier. GitHub Desktop crée le dépôt sur GitHub tout seul.
4. Supprimer l'ancien dépôt vide **`backup-pc`** sur github.com
   (`Settings` → tout en bas → `Delete this repository`).
5. Le dépôt `pc-linux-migration` apparaît alors sur
   [claude.ai/code](https://claude.ai/code) ; PC ↔ web se synchronisent ensuite par
   `Push origin` / `Pull origin`.

> Je n'ai pas pu créer le dépôt GitHub à ta place : ce terminal n'a ni la CLI `gh` ni
> tes identifiants GitHub. La création passe forcément par GitHub Desktop (ou le site).
