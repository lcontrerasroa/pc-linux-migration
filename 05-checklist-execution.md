# Checklist chronologique

## Phase A — Préparation (PC encore sous Windows)

### A1. Sauvegarde des données
- [x] 1re passe `scripts/backup.ps1` faite le 2026-09-04 (voir `01-plan-backup.md` §0)
- [x] **Rebrancher `D:`** (débranché après la 1re passe)
- [x] **iCloud Photos** : forcer le téléchargement des 52 originaux manquants
      (`_logs\Pictures_ECHECS_a_recuperer.txt`), attendre la fin, **relancer `backup.ps1`**
- [x] (optionnel) fermer Chrome + Signal, relancer `backup.ps1` pour les fichiers verrouillés
- [x] Relancer avec `-Verify` — colonne « Copies » ~0 partout
- [x] Ouvrir au hasard 5–10 fichiers dans `D:\BACKUP-PC-2026-09\` (photos, PDF, docx)
- [x] Vérifier `_PRIORITAIRE-Adrien\` en particulier (ouvrir quelques fichiers)
- [x] Ajouter à la main les dossiers « à vérifier un par un » de `01-plan-backup.md` §1
      que vous voulez garder (`C:\Users\cyber\data`, `Praat`, `Recorded Calls`, etc.)

### A2. Navigateurs
- [ ] Firefox : se connecter au compte Mozilla, forcer une synchro
- [ ] Chrome : idem compte Google
- [ ] Exporter les mots de passe de chaque navigateur en CSV → ranger dans un `.7z` chiffré
      sur `D:\BACKUP-PC-2026-09\`
- [ ] Exporter les favoris en HTML (secours)
- [ ] Noter la liste des extensions utiles

### A3. Dossiers cloud (détail dans `01-plan-backup.md` §3)
- [x] Google Drive : vérifier sur drive.google.com que `Documents` est bien en ligne
- [x] Google Drive : appli → Préférences → **Déconnecter le compte**
- [x] Nextcloud : vérifier côté serveur web → **Quitter** le client / retirer le compte
- [x] iCloud : vérifier sur icloud.com → **se déconnecter** d'iCloud pour Windows
- [x] OneDrive : vérifier en ligne → dissocier le PC

### A4. Exports « listes » (à mettre dans la sauvegarde)
- [ ] `conda env list` puis `conda env export -n <env> > <env>.yml` pour chaque environnement
- [ ] Sous R : `write.csv(as.data.frame(installed.packages()[,c("Package","Version")]), "r-packages.csv", row.names=FALSE)`
- [ ] Copier `%USERPROFILE%\.gitconfig`, config VS Code / Sublime si personnalisée
- [ ] Lister les polices installées manuellement (surtout API/linguistique)
- [ ] Noter les licences / clés de logiciels que vous voulez réutiliser (Reaper, Bitwig, etc.)

### A5. Clé USB d'installation
- [x] Distro retenue : **Fedora KDE 44** (`04-choix-distribution-linux.md`), Plasma 6, noyau 6.19
- [x] ISO téléchargée : `Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso` (3,2 Go)
- [x] SHA-256 vérifié contre le CHECKSUM officiel Fedora (2 miroirs) :
      `c8295961d4c41adbf785a31a17c21a971d3b7415fda72dcad0c11c49577bf03a`
- [x] Écriture sur la clé depuis Linux (ISO hybride, `dd` suffit — ni Etcher ni Ventoy) :
      ```bash
      sudo dd if=Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso of=/dev/sdX \
              bs=4M status=progress oflag=direct conv=fsync
      ```
      ⚠️ `/dev/sdX` = la clé **entière**, sans chiffre. Vérifier avec `lsblk -d -o NAME,SIZE,TRAN,MODEL`.
- [x] Vérification par empreinte, et **pas** avec `cmp` : le code de retour de `cmp` remonté
      à travers un wrapper s'est révélé faux dans les deux sens. La bonne méthode :
      ```bash
      echo 3 | sudo tee /proc/sys/vm/drop_caches
      sudo head -c 3368683520 /dev/sdX | sha256sum   # doit rendre le SHA-256 de l'ISO
      ```
- [x] Résultat : empreinte identique ✔ (clé lente, ~6,5 Mo/s en écriture et 16 Mo/s en
      lecture — le live mettra plusieurs minutes à démarrer, c'est normal)

### A6. Réglages BIOS et Windows
- [x] **BitLocker** : vérifié sur `E:` → `manage-bde -status E:` renvoie **0,0 % chiffré**.
      Rien à déchiffrer, le Toshiba sera lisible sous Linux.
- [x] **Démarrage rapide Windows désactivé** (`powercfg /h off` en PowerShell admin).
      Indispensable ici : il hiberne Windows au lieu de l'éteindre et laisse le *dirty bit*
      sur les volumes NTFS montés. Un `E:` marqué sale est monté **en lecture seule** par
      `ntfs3`, et Windows ne sera plus là pour le réparer. Puis **Arrêter**, pas Redémarrer.
- [x] **Mode BIOS = UEFI** confirmé via `msinfo32` (attendu : Windows 11 impose UEFI + GPT).
      Le CSM est donc déjà désactivé — ne rien changer dans le BIOS.
- [ ] Secure Boot : **laisser activé**, Fedora 44 est signé (le MOK n'arrive qu'au pilote NVIDIA)
- [ ] `Fast Boot` du BIOS (≠ démarrage rapide Windows) : n'y toucher que si **F8** ne donne
      rien au logo ASUS → `Suppr` → `F7` mode avancé → onglet `Boot` → `Fast Boot: Disabled`
- [ ] Noter le modèle exact du SSD affiché dans le BIOS (WD SN520) pour ne pas se tromper

## Phase B — Juste avant l'installation

- [ ] Sauvegarde vérifiée ✔ (dont `_PRIORITAIRE-Adrien\` ouvert et contrôlé)
- [ ] Comptes cloud déconnectés ✔ (Google Drive perso, Nextcloud UPJV, iCloud)
- [ ] **Débrancher le câble USB** du disque externe `D:` et le ranger (rien à ouvrir)
- [ ] Le disque Toshiba `E:` **reste branché** — on le protège dans l'installateur (Phase C)
- [ ] Brancher un **câble Ethernet** (le Wi-Fi Realtek peut ne pas marcher pendant le live)
- [ ] Insérer la clé USB Fedora KDE 44, démarrer dessus (**F8** au logo ASUS)
- [ ] Au menu de démarrage, choisir l'entrée préfixée **`UEFI:`** — la clé y apparaît
      souvent deux fois. Démarrer sur l'entrée non-UEFI installerait Fedora en mode BIOS
      sur un disque GPT : échec ou système qui ne démarre pas.

## Phase C — Installation (Fedora KDE 44 / installateur Anaconda)

> ⚠️ **Ne jamais transposer les noms de disques d'une machine à l'autre.**
> Sur le portable qui a servi à préparer la clé, `sda` était le SSD système.
> **Sur le ROG Strix, `sda` est le Toshiba `E:` à préserver**, et la cible est `nvme0n1`.
> Premier réflexe en live, avant de lancer l'installateur :
> ```bash
> lsblk -d -o NAME,SIZE,TRAN,MODEL
> ```
> Attendu : `nvme0n1` ≈ 238 Gio (WD SN520, **à effacer**) et `sda` ≈ 931 Gio
> (TOSHIBA DT01ACA100, **à ne pas cocher**).


- [ ] Démarrer en mode **live** (« Try Fedora ») avant d'installer
- [ ] Vérifier en live : affichage net, son OK, Ethernet OK, (Wi-Fi si possible),
      Plasma 6 + session Wayland
- [ ] Lancer « Installer sur le disque dur »
- [ ] **Destination de l'installation** :
      - **cocher UNIQUEMENT `WDC PC SN520` (~238 Gio)**
      - **laisser `TOSHIBA DT01ACA100` (~931 Gio, `DATA`) décoché**
- [ ] Partitionnement **Automatique** (Btrfs par défaut) — ou Personnalisé sur `nvme0n1` seul
- [ ] Chiffrement du disque (LUKS) si souhaité — **bien noter la phrase de passe**
- [ ] Écran de résumé : vérifier que **seul `nvme0n1` est marqué « formaté / effacé »**,
      jamais `sda`
- [ ] Lancer, créer l'utilisateur, redémarrer, retirer la clé USB

## Phase D — Post-installation (voir aussi `scripts/inventaire-post-install.md`)

### D1. Système & pilotes
- [ ] Mises à jour complètes (`sudo apt update && sudo apt full-upgrade` / `sudo dnf upgrade`)
- [ ] Installer le **pilote NVIDIA** :
      - Kubuntu : *Pilotes additionnels* → `nvidia-driver-5xx` (1 clic, MOK guidé)
      - Fedora KDE : RPM Fusion + `akmod-nvidia` + signature MOK (voir `04-choix-distribution-linux.md`)
      - Nobara / Pop!\_OS (ISO NVIDIA) : déjà présent, rien à faire
- [ ] Secure Boot : au redémarrage, écran MOK → **Enroll MOK** → mot de passe choisi
- [ ] Vérifier : `nvidia-smi` renvoie la carte et le pilote
- [ ] Vérifier que l'ancien `E:` (Toshiba, resté branché) est visible et lisible :
      `lsblk -f` puis le monter (NTFS lu/écrit via `ntfs3`)
- [ ] Rebrancher le disque externe `D:` (USB), vérifier la sauvegarde lisible

### D2. Wi-Fi (si instable)
- [ ] Tester la stabilité du Wi-Fi RTL8822CE sur plusieurs heures
- [ ] Si coupures : pilote DKMS à jour + option `disable_aspm=1` (`02-inventaire-materiel.md` §1)
      - Kubuntu : `sudo apt install rtw88-dkms`
      - Fedora : `sudo dnf copr enable kwizart/rtl8822ce` puis `sudo dnf install rtl8822ce`
        (ou compiler depuis `github.com/lwfinger/rtw88`)
- [ ] Sinon envisager la carte **Intel AX210** (~15–20 €, remplacement 5 min)

### D3. Restauration des données
- [ ] Copier depuis `D:\BACKUP-PC-2026-09\` vers `~/Téléchargements`, `~/Documents`,
      `~/Images`, `~/Bureau`
- [ ] Restaurer profils navigateurs (ou juste se reconnecter aux synchros)
- [ ] Réinstaller Signal → lier depuis le téléphone
- [ ] Zotero : installer, se connecter, laisser resynchroniser

### D4. Cloud sous Linux
- [ ] Nextcloud : installer le client officiel, reconnecter le compte
- [ ] Google Drive : rclone (`rclone config`) ou Insync ; ou navigateur
- [ ] OneDrive : `abraunegg/onedrive` ou rclone si besoin

### D5. Applications (voir `03-logiciels-equivalents-linux.md`)
- [ ] Bureautique : LibreOffice (souvent préinstallé) + ONLYOFFice si besoin `.docx` fidèle
- [ ] Navigateurs : Firefox, Chrome, Opera
- [ ] Comm : Discord, Zoom, Signal, (Teams web)
- [ ] Recherche : Praat, ELAN, CLAN, Phon, SPPAS, Zotero, R + RStudio, Miniforge/conda,
      pandoc, polices SIL
- [ ] Restaurer les environnements : `conda env create -f <env>.yml`, réinstaller packages R
- [ ] MAO : installer le DAW retenu (Reaper / Bitwig / Ardour), PipeWire-JACK,
      se mettre dans le groupe `audio`, yabridge si plugins Windows
- [ ] Multimédia : VLC/mpv, DaVinci Resolve, Flameshot, OBS
- [ ] Utilitaires : `p7zip`/`unrar`, FSearch, gestionnaire d'archives
- [ ] Imprimante HP Deskjet 3050A : installer `hplip` (`sudo apt install hplip` /
      `sudo dnf install hplip`) → ajouter l'imprimante dans les Paramètres (souvent
      détectée automatiquement via CUPS)

### D6. Confort
- [ ] Snapshots système : **Timeshift** (Kubuntu) ou **snapper** / outil Btrfs (Fedora,
      souvent déjà configuré avec `/` en Btrfs)
- [ ] Firewall : `sudo ufw enable` (Kubuntu) — Fedora a `firewalld` actif par défaut
- [ ] Disposition clavier + saisie API (ibus-table) si besoin phonétique
- [ ] KDE Connect / GSConnect pour le lien avec le téléphone

## Phase E — Nettoyage (après quelques semaines, une fois sûr de tout)

- [ ] Vérifier qu'il ne manque rien dans les données restaurées
- [ ] Ne **pas** effacer `D:\BACKUP-PC-2026-09\` avant au moins 1–2 mois d'usage Linux
- [ ] Reformater / réutiliser l'espace du Toshiba `E:` selon besoin
