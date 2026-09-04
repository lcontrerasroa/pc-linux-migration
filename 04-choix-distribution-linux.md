# Choix de la distribution Linux pour l'ASUS ROG Strix GL10DH

## Contraintes issues du matériel (voir `02-inventaire-materiel.md`)

| Contrainte | Conséquence sur le choix |
|---|---|
| Wi-Fi Realtek **RTL8822CE** capricieux | **Noyau récent fortement conseillé** (≥ 6.8, idéalement ≥ 6.11) |
| GPU **NVIDIA GTX 1660** (Turing) | Installation **simple** du pilote propriétaire souhaitée |
| **Secure Boot activé** | Distro signée + enrôlement MOK pour le module NVIDIA |
| APU **Ryzen 5 3400G / Vega 11** | Aucun souci sur noyau récent |
| Utilisateur « à l'aise occasionnellement » | Éviter les distros à maintenance lourde (Arch pur) |
| **Priorité : bureau beau, widgets, personnalisable** | → environnement de bureau **KDE Plasma** (ou COSMIC) |
| PC « assez puissant » (6c/12t + GTX 1660 + 16 Go) | Les effets de bureau, la 3D, Wayland : aucun problème |

> La MAO n'est plus une contrainte (l'utilisateur s'adapte à Bitwig/Reaper natifs).

## D'abord : le bureau, pas la distro

« Widgeteable / personnalisable / beau » se joue surtout au niveau de
**l'environnement de bureau**, pas de la distribution. Sur ce Pc puissant, tous
tournent sans souci.

| Bureau | Personnalisation | Widgets | Style par défaut | Pour vous |
|---|---|---|---|---|
| **KDE Plasma 6** | **Énorme** : thèmes globaux, panneaux multiples, effets KWin, règles de fenêtres, activités, Kvantum | **Oui, natifs** (bureau + panneaux) : météo, moniteur système, notes, etc. | Moderne, soigné | ✅ **Le meilleur choix ici** |
| **COSMIC** (Pop!\_OS, écrit en Rust) | Élevée, avec **tuilage natif** | En cours d'ajout | Épuré, élégant | ✅ Si vous aimez le tuilage, projet encore jeune |
| GNOME | Moyenne (via **extensions**) | Via extensions | Très épuré | ➖ Beau mais moins « widget » sans bricoler |
| Cinnamon (Mint) | Faible à moyenne (desklets) | Desklets modestes | Classique type Windows 7 | ➖ Stable mais pas « personnalisable » |
| Hyprland / tuilage pur | Illimitée (tout en config) | Via waybar/eww | Ce que vous en faites | ⚠️ Gros investissement, pas pour un usage « occasionnel » |

**Conclusion : viser une distribution qui livre KDE Plasma 6 proprement.**

Ce que KDE vous donnera concrètement :

- **Widgets (« plasmoïdes »)** sur le bureau et dans les panneaux : système, météo,
  agenda, notes, prévisions, contrôle média, etc. — plus un magasin intégré (« Get New… »).
- **Thèmes globaux**, thèmes d'icônes, thèmes Kvantum, couleurs, polices, effets de
  transparence/flou, coins arrondis — tout en GUI.
- **Panneaux multiples** (barre en haut, dock en bas facon macOS, etc.), **activités**,
  bureaux virtuels, **règles de fenêtres** (telle appli toujours ici, à cette taille…).
- **Tuilage** optionnel via script (KZones, Polonium, Krohnkite).
- **KDE Connect** : intégration téléphone (notifications, presse-papier, transfert).

## Comparatif des distributions (avec KDE)

| Distro (édition KDE) | Noyau (2026) | Pilote NVIDIA | Wi-Fi 8822CE d'origine | Secure Boot | Maintenance | Verdict |
|---|---|---|---|---|---|---|
| **Fedora KDE 42** | **6.13+** (très frais) | RPM Fusion + `akmod-nvidia` + signature MOK (procédure officielle, ~5 cmd) | **Très bon** (noyau récent) | Oui | Modérée, MàJ fréquentes mais stables | ✅ **Recommandé** |
| **Kubuntu 24.04 LTS** | 6.8 → HWE 6.11+ | « Pilotes additionnels » **en 1 clic**, MOK guidé | Correct (6.8), bon après HWE | Oui | Faible (LTS 5 ans) | ✅ **Recommandé** (option tranquille) |
| **Nobara (KDE)** — base Fedora | 6.13+ | **Préinstallé et signé**, + codecs | Très bon | Oui | Modérée, petite équipe (GloriousEggroll) | ✅ Bon si vous voulez « rien configurer » |
| **Pop!\_OS** (ISO NVIDIA, bureau COSMIC) | 6.12+ | **Préinstallé** (ISO NVIDIA) | Correct | Oui | Faible | ✅ Si COSMIC 24.04 est stable à la date d'install |
| **KDE neon** | 6.8 (base Ubuntu 22.04) | manuel | Moyen | Oui | Faible mais base OS vieillissante | ⚠️ Plasma le plus à jour, mais noyau/base datés |
| **openSUSE Tumbleweed KDE** | Rolling, très frais | Dépôt NVIDIA | Bon | Fiddly | Rolling (snapshots Btrfs très pratiques) | ⚠️ NVIDIA + Secure Boot un peu pénibles |
| **CachyOS / EndeavourOS (KDE)** — base Arch | Le plus récent | Assistant / AUR | Excellent | Partiel | **Élevée** (rolling Arch) | ⚠️ Superbe et rapide, mais demande de l'implication |
| **Linux Mint 22.x** (Cinnamon, **pas de KDE**) | 6.8 conservateur | 1 clic | Correct | Oui | Très faible | ➖ Le plus sûr, mais peu « personnalisable » — écarté vu vos priorités |

## Recommandation

### 1er choix — **Fedora KDE 42**

Le meilleur alignement avec vos priorités (**beau + personnalisable**) *et* ce matériel :

- **Noyau très récent** → le Wi-Fi Realtek RTL8822CE et l'APU Ryzen sont gérés au mieux
  **sans rien faire** ; Mesa/PipeWire de dernière génération.
- **KDE Plasma 6** dans son édition la plus soignée (Fedora KDE est devenue une édition
  phare officielle) : Wayland par défaut, très fluide sur GTX 1660.
- Base solide : Fedora est stable malgré son rythme, avec `dnf` fiable et de bons retours
  en arrière.
- **Point d'attention — NVIDIA** : il faut activer **RPM Fusion** puis installer
  `akmod-nvidia`, et **signer le module pour Secure Boot**. C'est documenté officiellement
  (RPM Fusion « Howto/NVIDIA ») et ça tient en quelques commandes :
  ```bash
  sudo dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
  # Secure Boot : générer et enrôler une clé de signature des modules
  sudo dnf install kmodtool akmods mokutil openssl
  sudo kmodgenca -a
  sudo mokutil --import /etc/pki/akmods/certs/public_key.der   # mot de passe, puis reboot -> Enroll MOK
  # attendre ~5 min que akmod compile, puis redémarrer
  ```
  (Ou, pour éviter cette étape : désactiver Secure Boot dans le BIOS — au choix.)

### 1er choix bis — **Kubuntu 24.04 LTS** (si vous voulez le moins de manipulations)

- **KDE Plasma** aussi, sur base **Ubuntu LTS** → NVIDIA en **1 clic**
  (« Pilotes additionnels » → `nvidia-driver-5xx`, l'assistant gère l'enrôlement MOK).
- Support 5 ans, mises à jour calmes.
- Contrepartie : noyau 6.8 au départ → si le Wi-Fi fait des siennes, installer le
  **noyau HWE** (`sudo apt install linux-generic-hwe-24.04`) qui monte vers 6.11+,
  et/ou `rtw88-dkms` (voir `02-inventaire-materiel.md` §1).
- Plasma légèrement moins récent que sur Fedora, mais la différence est mineure.

> **Comment trancher entre les deux :**
> - Vous acceptez ~5 commandes une fois pour NVIDIA, et vous voulez le matériel géré
>   au mieux d'origine → **Fedora KDE**.
> - Vous voulez le parcours le plus balisé, quitte à installer un noyau plus récent
>   à la main plus tard → **Kubuntu 24.04**.

### Si vous voulez « zéro configuration »

- **Nobara (KDE)** : Fedora avec NVIDIA + codecs + noyau optimisé **déjà en place**.
  Pensée pour la création/le jeu. Idéale pour ne toucher à rien ; l'équipe est petite,
  donc dépendez-en en connaissant ce compromis.
- **Pop!\_OS (ISO NVIDIA)** : pilote NVIDIA intégré à l'image. Bureau **COSMIC** très
  élégant avec tuilage natif — vérifier que la version 24.04 est stable au moment de
  l'installation (sinon la base 22.04 date un peu).

### Écarté

- **Linux Mint / Cinnamon** : imbattable en stabilité et simplicité NVIDIA, mais noyau
  conservateur (risque Wi-Fi) et Cinnamon offre peu de personnalisation/widgets.
  À ne retenir que si « rien qui bouge, jamais » prime sur « beau et modulable ».
- **Arch et dérivés** (CachyOS, EndeavourOS, Manjaro) : rendu superbe et performances
  de pointe, mais la maintenance rolling Arch dépasse un usage « occasionnel ».

## Ce qu'il faut télécharger et vérifier

1. ISO depuis le **site officiel** (getfedora.org / kubuntu.org / nobaraproject.org /
   system76.com). Jamais un miroir tiers douteux.
2. **Vérifier la somme de contrôle** SHA256 publiée sur le site :
   ```powershell
   Get-FileHash -Algorithm SHA256 "$HOME\Downloads\<image>.iso"
   ```
3. Écrire l'ISO sur une **clé USB ≥ 8 Go** (⚠️ pas le disque de sauvegarde) :
   **balenaEtcher** (déjà installé) ou **Rufus** (mode *GPT / UEFI*, non-CSM).
4. Toutes ces distros ont un **mode « live »** : démarrer dessus **sans installer** pour
   vérifier d'abord :
   - le **Wi-Fi** se connecte et **tient** (laisser un `ping -i 2 1.1.1.1` tourner),
   - l'**affichage** est net (bonne résolution, pas de tearing),
   - le **son** sort,
   - clavier / souris / USB répondent.
   - Sur KDE : ouvrir *Paramètres système → À propos* pour confirmer Plasma 6 + Wayland.

## Réglages BIOS avant installation

- Mode **UEFI** (pas Legacy / CSM).
- **Secure Boot** : peut rester **activé** (Fedora, Kubuntu, Nobara, Pop le gèrent).
  Le désactiver simplifie l'étape NVIDIA sur Fedora — à vous de voir.
- **Fast Boot** : désactivé (sinon la clé USB peut ne pas être détectée).
- Côté Windows encore en place : désactiver **« Démarrage rapide »**
  (Options d'alimentation) avant de toucher aux partitions.
- Ordre de démarrage : USB en premier, ou **F8** au logo ASUS.

## Partitionnement (install sur le SSD NVMe uniquement)

- Cible : **WD PC SN520, 238 Go** (le seul disque restant si le Toshiba est débranché).
- Schéma simple :
  - `EFI` : 512 Mo (FAT32, `/boot/efi`) — créé par l'installateur
  - `/` : tout le reste. **Btrfs** conseillé (Fedora le fait par défaut) → snapshots
    système faciles (`snapper` / outil intégré). Sinon **ext4**, très bien aussi.
  - **swap** : fichier d'échange 8–16 Go géré par l'installateur (pas de partition
    dédiée nécessaire avec 16 Go de RAM ; `zram` est activé par défaut sur Fedora).
- Option « Effacer le disque » = OK **puisque le Toshiba est débranché**. Sinon mode
  manuel et sélection explicite du SN520.

## Après installation → voir `05-checklist-execution.md` et `scripts/inventaire-post-install.md`

Premiers gestes KDE pour « rendre la machine belle » :

- *Paramètres système → Apparence → Thème global* : essayer les thèmes, en installer
  d'autres (« Get New Global Themes… »), idem icônes et curseurs.
- *Effets de bureau* : activer flou, « Wobbly Windows », magic lamp, etc.
- Clic droit sur le bureau / panneau → *Ajouter des widgets* → en télécharger
  (moniteur système, météo, etc.).
- Ajouter un second panneau en dock (style macOS) si voulu.
- Installer **Kvantum** (`kvantummanager`) pour les thèmes d'applications avancés.
- Store de widgets et thèmes : tout passe par *Get New…* dans les dialogues KDE.
