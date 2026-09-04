# Checklist chronologique

## Phase A — Préparation (PC encore sous Windows)

### A1. Sauvegarde des données
- [ ] Brancher le disque externe WD My Passport (`D:`), vérifier ~291 Go libres
- [ ] Créer `D:\BACKUP-PC-2026-09\`
- [ ] Lancer `scripts/backup.ps1` (voir en-tête du script pour l'usage)
- [ ] Relancer avec `-Verify` — la liste des différences doit être quasi vide
- [ ] Ouvrir au hasard 5–10 fichiers dans `D:\BACKUP-PC-2026-09\` (photos, PDF, docx)
- [ ] Ajouter à la main les dossiers « à vérifier un par un » de `01-plan-backup.md` §1
      que vous voulez garder (`C:\Users\cyber\data`, `Praat`, `Recorded Calls`, etc.)

### A2. Navigateurs
- [ ] Firefox : se connecter au compte Mozilla, forcer une synchro
- [ ] Chrome : idem compte Google
- [ ] Exporter les mots de passe de chaque navigateur en CSV → ranger dans un `.7z` chiffré
      sur `D:\BACKUP-PC-2026-09\`
- [ ] Exporter les favoris en HTML (secours)
- [ ] Noter la liste des extensions utiles

### A3. Dossiers cloud (détail dans `01-plan-backup.md` §3)
- [ ] Google Drive : vérifier sur drive.google.com que `Documents` est bien en ligne
- [ ] Google Drive : appli → Préférences → **Déconnecter le compte**
- [ ] Nextcloud : vérifier côté serveur web → **Quitter** le client / retirer le compte
- [ ] iCloud : vérifier sur icloud.com → **se déconnecter** d'iCloud pour Windows
- [ ] OneDrive : vérifier en ligne → dissocier le PC

### A4. Exports « listes » (à mettre dans la sauvegarde)
- [ ] `conda env list` puis `conda env export -n <env> > <env>.yml` pour chaque environnement
- [ ] Sous R : `write.csv(as.data.frame(installed.packages()[,c("Package","Version")]), "r-packages.csv", row.names=FALSE)`
- [ ] Copier `%USERPROFILE%\.gitconfig`, config VS Code / Sublime si personnalisée
- [ ] Lister les polices installées manuellement (surtout API/linguistique)
- [ ] Noter les licences / clés de logiciels que vous voulez réutiliser (Reaper, Bitwig, etc.)

### A5. Clé USB d'installation
- [ ] Choisir la distro (`04-choix-distribution-linux.md` — recommandé : **Fedora KDE 42**,
      ou **Kubuntu 24.04** pour le parcours le plus simple ; bureau **KDE Plasma 6**)
- [ ] Télécharger l'ISO depuis le site officiel
- [ ] Vérifier le SHA256 (`Get-FileHash -Algorithm SHA256 <iso>`)
- [ ] Écrire sur une clé USB ≥ 8 Go avec balenaEtcher (⚠️ **pas** le disque de sauvegarde)

### A6. Réglages BIOS
- [ ] Windows : désactiver « Démarrage rapide » (options d'alimentation)
- [ ] Redémarrer, entrer dans le BIOS (Suppr au logo ASUS)
- [ ] Mode UEFI (pas CSM) · Fast Boot désactivé · Secure Boot peut rester activé
- [ ] Noter le modèle exact du SSD affiché dans le BIOS (WD SN520) pour ne pas se tromper

## Phase B — Juste avant l'installation

- [ ] Sauvegarde vérifiée ✔ (dont `_PRIORITAIRE-Adrien\` ouvert et contrôlé)
- [ ] Comptes cloud déconnectés ✔ (Google Drive perso, Nextcloud UPJV, iCloud)
- [ ] **Débrancher le câble USB** du disque externe `D:` et le ranger (rien à ouvrir)
- [ ] Le disque Toshiba `E:` **reste branché** — on le protège dans l'installateur (Phase C)
- [ ] Brancher un **câble Ethernet** (le Wi-Fi Realtek peut ne pas marcher pendant le live)
- [ ] Insérer la clé USB Fedora KDE 42, démarrer dessus (F8 au logo ASUS)

## Phase C — Installation (Fedora KDE 42 / installateur Anaconda)

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
