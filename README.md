# Migration Windows → Linux — ASUS ROG Strix GL10DH

Projet de préparation au passage sous Linux : sauvegarde des données essentielles,
inventaire des logiciels et de leurs équivalents Linux, choix de la distribution
adaptée au matériel.

- **Machine** : ASUS ROG Strix GL10DH_GL10DH (tour de bureau)
- **Objectif** : effacement complet du SSD NVMe (actuellement Windows 11) et installation de Linux
- **Données à préserver** : Téléchargements (2 emplacements), Documents, Images, Bureau
- **Ne pas conserver** : jeux Steam, logiciels Windows non compatibles Linux
- **Cible de sauvegarde** : disque externe USB WD My Passport (lettre `D:`, 291 Go libres)
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

Ce dossier est un dépôt Git relié à **`https://github.com/lcontrerasroa/backup-pc.git`**
(remote `origin`, branche `main`).

Premier envoi — via **GitHub Desktop** (il a les identifiants GitHub ; ce terminal ne
les a pas) :

1. `File` → `Add local repository…` → `C:\Users\cyber\github\pc-linux-migration`
2. Bouton **`Push origin`** (ou `Publish branch`).
3. Si GitHub Desktop signale un conflit d'historique (parce que le dépôt `backup-pc`
   a été créé avec un README sur GitHub) : le dépôt est neuf et ne contient rien
   d'important, donc soit
   - `git pull origin main --allow-unrelated-histories` puis `git push`, soit
   - `git push -u origin main --force` (écrase le README auto-généré).

Ensuite : le dépôt apparaît sur [claude.ai/code](https://claude.ai/code), on peut y
lancer une session cloud. PC ↔ web restent synchronisés par `Push origin` / `Pull origin`.

> Le nom du dépôt est `backup-pc` mais le projet couvre toute la migration ; on peut
> le renommer sur GitHub (`Settings → Repository name`) sans casser le lien si besoin.
