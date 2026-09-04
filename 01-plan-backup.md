# Plan de sauvegarde

Objectif : copier tout ce qui vit **sur le SSD système** (qui sera effacé) vers le
disque externe `D:` (WD My Passport, 291 Go libres), puis vérifier, puis seulement
après lancer l'installation de Linux.

Tout ce qui est sur `E:` (Toshiba) et `D:` (externe) **survit** si on n'efface que le
SSD — mais on sécurise quand même (voir §4).

## 1. Ce qui doit être sauvegardé (sur le SSD `C:`)

| Source | Taille | Nb fichiers | Note |
|---|---:|---:|---|
| 🔴 `C:\Users\cyber\Desktop\Adrien` | ~15,8 Go | 5 969 | **PRIORITÉ ABSOLUE.** Déjà inclus dans `Desktop`, mais copié **aussi** dans un dossier isolé `_PRIORITAIRE-Adrien\` et vérifié à part. |
| `C:\Users\cyber\Downloads` | ~39 Go | 1 300 | Téléchargements principaux |
| `C:\Users\cyber\Documents` | ~2,5 Go | 39 569 | **Synchronisé Google Drive** — voir §3 |
| `C:\Users\cyber\Pictures` | ~9,5 Go | 1 796 | Images — c'est en fait presque entièrement la **photothèque iCloud** (`iCloud Photos`). La sauvegarde la fige en local avant de déconnecter iCloud. |
| `C:\Users\cyber\Desktop` | ~22,8 Go | 44 993 | Bureau (beaucoup de petits fichiers → copie longue). Contient `Adrien\`. |
| `C:\Users\cyber\iCloudDrive` | ~0,07 Go | 36 | Pas de client iCloud sous Linux → copie locale indispensable. |
| **Sous-total (Adrien compté une seule fois)** | **~74 Go** | | |

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

Trois moteurs de synchronisation sont installés et **doivent tous être déconnectés
avant l'effacement** :

1. **Google Drive** (compte perso — dossier `Documents` synchronisé)
2. **Nextcloud — instance de l'UPJV** (Université de Picardie Jules Verne)
3. **iCloud** (iCloud Drive + iCloud pour Windows / Outlook)

La crainte est justifiée : si un client de synchro voit ses fichiers locaux disparaître,
il peut propager la suppression vers le cloud.

**Double sécurité appliquée :** (a) copie « morte » complète sur le disque externe `D:`
via `scripts/backup.ps1`, **et** (b) déconnexion des trois comptes avant de formater.
La copie sur `D:` est la vraie garantie ; la déconnexion évite toute propagation de
suppression pendant qu'on manipule les partitions.

Ordre recommandé : vérifier en ligne → lancer la sauvegarde `D:` → vérifier la
sauvegarde → **puis seulement** déconnecter les comptes → formater.

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

### Nextcloud — instance UPJV (`E:\Nextcloud`, `D:\nextcloud-data`, client 3.4.0)

1. Se connecter à l'interface web du Nextcloud de l'UPJV et **vérifier que tous les
   fichiers y sont bien synchronisés** (pas de flèche « en cours », pas de conflit).
2. Client Nextcloud (icône barre des tâches) → ouvrir → **Compte → Supprimer le compte**,
   ou au minimum **Quitter** l'application (pas juste fermer la fenêtre).
   Supprimer le compte du client est le plus sûr : plus aucun lien local ↔ serveur.
3. Noter l'**URL du serveur UPJV** et l'identifiant pour reconfigurer plus tard.
   Si l'UPJV utilise un mot de passe d'application dédié pour le client, en régénérer
   un au besoin après réinstallation.
4. Le client Nextcloud existe **nativement sous Linux** (paquet officiel / Flatpak) :
   réinstallation et reconnexion simples ensuite.

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
10. **Débrancher le disque externe `D:`** (juste le câble USB — rien à ouvrir) et le ranger.
    Ainsi seuls les 2 disques internes restent visibles pendant l'installation.
11. **Le disque Toshiba `E:` reste branché** (pas besoin d'ouvrir la tour). La sécurité se
    fait alors **dans l'installateur Fedora** — voir §6 ci-dessous.
12. Lancer l'installation Linux en sélectionnant **uniquement le SSD NVMe** comme cible.
13. Après installation et premier démarrage OK : rebrancher le disque externe,
    vérifier que `E:` et la sauvegarde sont lisibles, **puis** commencer la restauration.

## 6. Ne pas pouvoir débrancher `E:` — comment rester en sécurité

Pas besoin d'ouvrir la tour. L'installateur de **Fedora (« Anaconda »)** liste tous les
disques et **ne touche qu'à ceux que vous cochez**.

1. Débrancher le **disque externe USB `D:`** (simple câble) → il ne reste que 2 disques.
2. Dans l'écran **« Destination de l'installation »**, deux pastilles de disque apparaissent :
   - **`WDC PC SN520` — ~238 Gio** → **la cocher** (c'est la cible Linux)
   - **`TOSHIBA DT01ACA100` — ~931 Gio, étiquette `DATA`** → **la laisser décochée**
   La taille (238 vs 931 Gio) et l'étiquette rendent la confusion quasi impossible.
3. Choisir le partitionnement **« Automatique »** : Anaconda ne partitionnera **que** le
   SN520 coché. (Ou « Personnalisé » et créer les partitions uniquement sur `nvme0n1`.)
4. À l'écran de résumé avant écriture, **vérifier** que la ligne « sera formaté / effacé »
   ne mentionne que `nvme0n1` (le SN520) et **jamais** `sda` (le Toshiba).
5. Ne pas cocher l'option éventuelle « utiliser tout l'espace disponible sur tous les
   disques » — rester sur le seul disque sélectionné.

> C'est la méthode standard pour installer sur une machine multi-disques. Des millions
> de gens le font sans jamais débrancher quoi que ce soit. Le débranchement physique
> n'est qu'un « niveau de paranoïa » supplémentaire, pas une nécessité.

## 5. Estimation de volume

```
_PRIORITAIRE-Adrien (C:)   ~15,8 Go   (copie dédiée ; ces fichiers sont AUSSI dans Desktop)
Downloads (C:)             ~39,0 Go
Documents (C:)              ~2,5 Go
Pictures (C:)               ~9,5 Go
Desktop (C:)               ~22,8 Go   (inclut Adrien)
iCloudDrive (C:)            ~0,1 Go
Vieux téléchargements (E:) ~36,7 Go
Profils / Signal / divers   ~1–2 Go
---------------------------------
TOTAL écrit sur D:        ~127–132 Go     (D: dispose de 291,9 Go libres → OK)
```
