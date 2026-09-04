# Plan de sauvegarde

Objectif : copier tout ce qui vit **sur le SSD système** (qui sera effacé) vers le
disque externe `D:` (WD My Passport, 291 Go libres), puis vérifier, puis seulement
après lancer l'installation de Linux.

Tout ce qui est sur `E:` (Toshiba) et `D:` (externe) **survit** si on n'efface que le
SSD — mais on sécurise quand même (voir §4).

## 1. Ce qui doit être sauvegardé (sur le SSD `C:`)

| Source | Taille | Nb fichiers | Note |
|---|---:|---:|---|
| `C:\Users\cyber\Downloads` | ~39 Go | 1 300 | Téléchargements principaux |
| `C:\Users\cyber\Documents` | ~2,5 Go | 39 569 | **Synchronisé Google Drive** — voir §3 |
| `C:\Users\cyber\Pictures` | ~9,5 Go | 1 796 | Images |
| `C:\Users\cyber\Desktop` | ~22,8 Go | 44 993 | Bureau (beaucoup de petits fichiers → copie longue) |
| **Sous-total dossiers principaux** | **~74 Go** | | |

### « Téléchargements sur les deux partitions »

- `C:\Users\cyber\Downloads` → déjà dans le tableau ci-dessus.
- `D:\Téléchargements`, `D:\Musiques`, `D:\Photos`, `D:\Enregistrements` : **vides** (0 fichier) — rien à faire.
- `E:\Vieux téléchargements` → **~36,7 Go, 423 fichiers**. Sur le disque Toshiba, donc
  survit à l'effacement du SSD, mais **à inclure dans la sauvegarde par sécurité**
  (au cas où le mauvais disque serait sélectionné pendant l'install).

### Les « oublis classiques » à ne pas rater (aussi sur `C:`)

| Élément | Chemin Windows | Comment le récupérer |
|---|---|---|
| Profils navigateurs (favoris, onglets, mots de passe, extensions) | Firefox : `%APPDATA%\Mozilla\Firefox\Profiles` (~70 Mo) · Chrome : `%LOCALAPPDATA%\Google\Chrome\User Data` · Opera : `%APPDATA%\Opera Software` | **Idéal** : activer la synchro de chaque navigateur (compte Mozilla / Google) + **exporter les mots de passe en CSV** et les ranger dans un fichier chiffré. **Secours** : copier les dossiers de profil. |
| Signal Desktop (historique local) | `%APPDATA%\Signal` (~50 Mo) | L'historique est **local**. Le plus propre : « lier un nouvel appareil » depuis le téléphone après install. Sinon copier le dossier (restauration non garantie entre OS). |
| Zotero (bibliothèque + PDF) | `C:\Users\cyber\Zotero` (~11 Mo ici) | Vérifier que la synchro Zotero est active (compte). Copier le dossier en secours. |
| Config Git / GitHub Desktop | `%USERPROFILE%\.gitconfig`, `%APPDATA%\GitHub Desktop` | Reconfigurer sous Linux (nom, e-mail, connexion GitHub). Pas de clés SSH présentes sur ce PC. |
| Dossiers de travail dans le profil | `C:\Users\cyber\data`, `Praat`, `Pragmatic_Similarity_Computation`, `Spa_tgt`, `ELAN-TOOLS`, `.correlatore`, `Recorded Calls` | À copier s'ils contiennent du travail — **à vérifier un par un**. |
| Préférences applis (Praat, ELAN, VS Code, Sublime, RStudio…) | Variable (souvent `%APPDATA%\<appli>`) | Copier les dossiers de config utiles ; la plupart des applis se reconfigurent vite. |
| Environnements Python / R | `anaconda3`, `.conda`, R packages | **Ne pas copier.** Exporter la liste : `conda env export > envs.yml` par environnement ; sous R : `write.csv(installed.packages()[,"Package"], "r-packages.csv")`. Réinstaller sous Linux. |
| Polices installées (linguistique : Charis SIL, Doulos, Phonetic Keyboard…) | `C:\Windows\Fonts` | Se réinstallent depuis les sites d'origine (SIL) ; ou copier les .ttf/.otf non-système. |
| Mail local éventuel (iCloud Outlook, PST) | `%LOCALAPPDATA%\Microsoft\Outlook` | Si comptes en IMAP : rien à faire. Si archives PST locales : les copier. |
| Enregistrements / notes diverses | `C:\Users\cyber\Recorded Calls`, `Music`, `Videos`, `3D Objects`, `Contacts`, `Favorites` | Vérifier le contenu, copier si utile. |

> Le script `scripts/backup.ps1` copie les 4 dossiers principaux + `E:\Vieux téléchargements`
> + les profils navigateurs + Signal + Zotero + `.gitconfig`. Les « à vérifier un par un »
> restent à ajouter manuellement selon ce que vous voulez garder.

## 2. Ce qui ne doit **pas** être sauvegardé

- **Jeux Steam / Rockstar / Paradox / FFXIV / Minecraft** — `E:\SteamLibrary`, `E:\Rockstar`, etc.
  Se retéléchargent. (Note : Steam fonctionne nativement sous Linux et Proton fait tourner
  la grande majorité de cette ludothèque — mais ce n'est pas une donnée à sauvegarder.)
- **Logiciels Windows** (binaires, installeurs) — voir `03-logiciels-equivalents-linux.md`
  pour savoir lesquels ont un équivalent Linux.
- **Windows lui-même**, `Program Files`, `Windows`, `AppData` en entier
  (on ne prend que des sous-dossiers ciblés).
- Caches divers, `AppData\Local\Temp`, corbeille.

## 3. Sécuriser les dossiers synchronisés dans le cloud (IMPORTANT)

Trois moteurs de synchronisation sont installés : **Google Drive**, **Nextcloud**, **iCloud**.
La crainte est justifiée : si un client de synchro voit ses fichiers locaux disparaître,
il peut propager la suppression vers le cloud. Procédure sûre :

### Google Drive (« Google Drive pour ordinateur », dossier `Documents` synchronisé)

1. Ouvrir **drive.google.com** dans le navigateur et **vérifier visuellement** que le
   contenu de `Documents` est bien présent en ligne :
   - soit sous **Mon Drive**, soit sous **Ordinateurs → (nom de ce PC)** selon le mode de synchro.
2. Faire quand même la **copie locale indépendante** vers `D:` (script de sauvegarde) —
   c'est la vraie sécurité, une copie non reliée à aucune synchro.
3. Dans l'appli Google Drive : `Paramètres` → `Préférences` → onglet compte →
   **« Déconnecter le compte »**. Ainsi, même si quelque chose tourne encore, plus rien
   ne peut être propagé.
4. Une fois l'effacement fait, l'appli n'existe plus : aucune suppression ne peut partir
   du PC. Au pire, en se reconnectant plus tard sous Linux (via navigateur / rclone /
   Insync), Drive **re-téléchargera** les fichiers.

> Pas de client Google Drive officiel sous Linux. Options après install :
> navigateur seul, **rclone** (gratuit, en ligne de commande, montage possible),
> **Insync** (payant, interface graphique), **Celeste**, ou **GNOME Online Accounts**
> si environnement GNOME.

### Nextcloud (`E:\Nextcloud`, `D:\nextcloud-data`, client 3.4.0)

1. Vérifier sur le serveur Nextcloud (interface web) que les fichiers sont à jour.
2. Client Nextcloud → **Quitter** (pas juste fermer la fenêtre) ou **supprimer le compte**
   du client avant l'effacement.
3. Le client Nextcloud existe **nativement sous Linux** : réinstallation simple ensuite.

### iCloud (`iCloudDrive`, iCloud Outlook)

1. Vérifier sur **icloud.com** que les fichiers voulus sont présents.
2. Se **déconnecter** d'iCloud pour Windows avant l'effacement.
3. Sous Linux : pas de client iCloud → accès via **icloud.com** uniquement
   (ou récupération ponctuelle des fichiers voulus dans la sauvegarde `D:`).

> **Règle d'or** : la sauvegarde sur `D:` est une copie « morte », non synchronisée.
> C'est elle la vraie sécurité. Les manip de déconnexion ci-dessus ne servent qu'à
> éviter toute propagation de suppression *avant* l'effacement.

## 4. Procédure de sauvegarde pas à pas

1. **Brancher** le disque externe WD My Passport (`D:`). Vérifier les 291 Go libres.
2. Créer le dossier `D:\BACKUP-PC-2026-09\`.
3. Lancer `scripts/backup.ps1` (PowerShell). Il utilise `robocopy` **sans option de
   miroir** : il ne supprime jamais rien sur la destination.
4. Laisser tourner (le Bureau et Documents ont beaucoup de petits fichiers → comptez
   un moment). Les journaux vont dans `D:\BACKUP-PC-2026-09\_logs\`.
5. **Vérifier** :
   - relancer le script en mode `-Verify` (passe `robocopy /L`, liste ce qui différerait
     encore — la liste doit être quasi vide) ;
   - comparer tailles et nombres de fichiers (le script affiche un récapitulatif) ;
   - ouvrir au hasard 5–10 fichiers depuis `D:\BACKUP-PC-2026-09\` (photos, docs, PDF).
6. Ajouter **manuellement** dans `D:\BACKUP-PC-2026-09\` les dossiers « à vérifier un par un »
   que vous voulez garder (§1).
7. Sécuriser les dossiers cloud (§3) : vérifs en ligne + déconnexion des comptes.
8. Exporter mots de passe navigateurs + activer les synchros de navigateur.
9. **Créer la clé USB Linux** (voir `04-choix-distribution-linux.md`) — sur une 2e clé,
   pas sur le disque de sauvegarde.
10. **Débrancher le disque externe `D:`** et le ranger.
11. **Ouvrir la tour et débrancher le disque Toshiba** (`E:`) — câbles SATA + alimentation.
    (Optionnel mais c'est la garantie absolue de ne pas l'effacer.)
12. Il ne reste que le SSD NVMe → lancer l'installation Linux.
13. Après installation et premier démarrage OK : rebrancher le Toshiba, puis le disque
    externe, vérifier que tout est lisible, **puis** commencer la restauration.

## 5. Estimation de volume

```
Downloads (C:)            ~39,0 Go
Vieux téléchargements (E:) ~36,7 Go
Documents (C:)             ~2,5 Go
Pictures (C:)              ~9,5 Go
Desktop (C:)              ~22,8 Go
Profils / Signal / divers  ~1–2 Go
--------------------------------
TOTAL                    ~110–115 Go     (D: dispose de 291 Go libres → OK)
```
