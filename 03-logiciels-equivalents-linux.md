# Logiciels installés → disponibilité / équivalents Linux

Légende :

- 🟢 **Natif** — version Linux officielle, installation directe
- 🟡 **Équivalent** — pas ce logiciel, mais un remplaçant Linux crédible
- 🌐 **Web** — utilisable via navigateur uniquement
- 🍷 **Wine** — pas de version Linux, fonctionne plus ou moins via Wine/Proton/Bottles
- 🔴 **Rien** — pas de solution Linux satisfaisante

---

## 1. Son & musique  ⚠️ le point qui mérite réflexion

| Logiciel installé | Statut | Détail |
|---|---|---|
| **Ableton Live 12 Intro** | 🔴 / 🟡 | Pas de version Linux. Tourne mal via Wine, non recommandé pour du vrai travail. **Équivalent** : **Bitwig Studio** (payant, créé par d'anciens de chez Ableton, flux de travail très proche) — c'est la migration naturelle. |
| **FL Studio 20** | 🍷 / 🟡 | Pas de version Linux native. Fonctionne « correctement » via Wine/Bottles + **yabridge** pour les plugins ; support officiel expérimental, stabilité/latence variables. **Équivalent natif** : **LMMS** (gratuit, esprit FL) ou Reaper. |
| **Cakewalk by BandLab** | 🔴 / 🟡 | Windows uniquement. Remplaçants : **Reaper**, **Ardour**, **Waveform Free**. |
| **Melodyne 5** (Celemony) | 🔴 | Windows/Mac uniquement, protection iLok. En VST via yabridge : aléatoire. **Équivalent partiel** : correction de hauteur dans Reaper (ReaTune), **GDX/x42**, ou **Ultimate Vocal Remover** + retouche manuelle. Pas d'équivalent au niveau de Melodyne. |
| **Arturia Software Center** + pilotes | 🔴 | Instruments Arturia = Windows/Mac. VST3 via yabridge : parfois OK, souvent bloqué par la protection. |
| **Audacity 2.4 / 3.7** | 🟢 | Version Linux officielle (souvent via Flatpak). Rien à changer. |
| **ASIO4ALL / FL Studio ASIO / Ableton USB Audio Driver** | 🟡 | Notion d'ASIO inexistante sous Linux : remplacée par **PipeWire** (+ `pipewire-jack`). Faible latence native, gère les interfaces USB class-compliant sans pilote. |
| **YAMAHA SEQTRAK App** | 🔴 / 🌐 | Appli Windows/Mac. Gestion basique possible en MIDI/USB direct ; sinon via l'appli mobile. |
| **Blackmagic RAW / DaVinci Resolve (audio Fairlight)** | 🟢 | DaVinci Resolve a une **version Linux officielle** (page Blackmagic). Fairlight pour l'audio à l'image y fonctionne. |

### Recommandation « son & musique »

Vous avez choisi l'effacement complet. À intégrer :

- **Si la MAO (Ableton/FL + Melodyne/Arturia) est centrale dans votre travail**, un
  effacement total est un vrai renoncement. Trois voies :
  1. **Adopter Bitwig Studio ou Reaper** nativement (le plus sain à long terme) ;
  2. garder **un double amorçage Windows** réduit, dédié à la MAO (contredit le choix actuel) ;
  3. Windows en **machine virtuelle avec passage du GPU** (avancé).
- **Si la MAO est occasionnelle**, la pile Linux moderne suffit largement :
  - DAW : **Reaper** (~60 $, excellent) ou **Ardour** (don libre) ou **Bitwig** ;
  - synthés natifs : **Vital**, **Surge XT**, **Odin 2**, **u-he** (natif Linux !) ;
  - effets : **LSP**, **Calf**, **x42**, **Airwindows** ;
  - pont plugins Windows : **yabridge** + Wine ;
  - audio système : **PipeWire** + `pipewire-jack` ; ajouter l'utilisateur au groupe
    `audio`, régler `rtprio`/`memlock` pour la faible latence.

---

## 2. Bureautique

| Logiciel installé | Statut | Détail |
|---|---|---|
| **LibreOffice 25.8** | 🟢 | Déjà multiplateforme, version Linux identique. Rien à faire. |
| **Microsoft Office 2016** (Word/Excel/PowerPoint, Pro Plus) | 🌐 / 🟡 | Pas de version Linux. Options : **Office sur le web** (gratuit, compte Microsoft), **LibreOffice**, ou **ONLYOFFice Desktop** (meilleure fidélité `.docx`/`.xlsx`/`.pptx` que LibreOffice). Cas complexes (macros VBA, mise en page pointue) : Windows en VM. |
| **Microsoft Project** | 🔴 / 🟡 | Windows uniquement. Équivalents : **ProjectLibre** (🟢, lit/écrit le `.mpp`), **GanttProject** (🟢), **OpenProject** (🌐, serveur). |
| **Microsoft Visio** | 🔴 / 🟡 | Windows uniquement. Équivalents : **draw.io / diagrams.net** (🟢, que vous avez déjà), **yEd**, **LibreOffice Draw**. draw.io importe partiellement le `.vsdx`. |
| **Google Docs / Sheets / Slides** (PWA Chrome) | 🌐 | Fonctionnent dans n'importe quel navigateur Linux ; on peut recréer les raccourcis PWA depuis Chrome/Chromium. |
| **Adobe Acrobat Reader** | 🟡 | Pas de version Linux à jour. Lecture : **Okular**, **Evince**, Firefox. Annotation/remplissage : **Okular**, **Xournal++**. Manipulation : **PDF Arranger**, `qpdf`, `pdftk`. |
| **draw.io 20.3** | 🟢 | Version Linux (AppImage / `.deb` / Flatpak). |
| **Batch Text Replacer / Bulk Rename Utility** | 🟡 | Remplacer par : `sed`/`rg`+`sd` en ligne de commande, **KRename** ou **GPRename** (renommage en masse GUI), **Métamorphose**. |

---

## 3. Recherche · linguistique · phonétique  (votre domaine — très bien couvert)

| Logiciel installé | Statut | Détail |
|---|---|---|
| **Praat** | 🟢 | Version Linux officielle. |
| **ELAN 5.9 / ELAN-CorpA 5.71** | 🟢 | Java, version Linux officielle (MPI Nijmegen). |
| **CLAN (CHILDES)** | 🟢 | Version Linux disponible (binaire ou compilation depuis les sources CMU). |
| **Phon 3.2** | 🟢 | Java, multiplateforme. |
| **SPPAS 3.5** | 🟢 | Python, multiplateforme (dépend de `wxPython`/`julius` selon fonctions). |
| **Zotero 5** | 🟢 | Version Linux officielle (`.tar.bz2` + `zotero-deb`, ou Flatpak). Vérifier la synchro compte avant migration. |
| **Mendeley Desktop 1.19** | 🟡 | Ancienne version, dépréciée. Sous Linux : **Mendeley Reference Manager** (AppImage) ou passage à **Zotero** (recommandé). |
| **R 4.0.2 + RStudio 2024.12** | 🟢 | Natifs Linux, souvent plus à l'aise que sous Windows. Exporter la liste des packages avant, réinstaller après. |
| **Anaconda3 / Python 3.2 & 3.8** | 🟢 | Natif. Migrer vers **Miniforge/conda** ou `venv`+`pip`. Exporter chaque environnement (`conda env export`). |
| **Praat / Correlatore / VizLing / SPPAS scripts** | 🟢 | Scripts portables (Praat, Python, R) — fonctionnent tels quels. |
| **pandoc 3.8** | 🟢 | Natif Linux (`apt`/`dnf`). |
| **Strawberry Perl** | 🟡 | Sous Linux, Perl est déjà là (`perl`, `cpanminus`). |
| **Java 8 (Oracle)** | 🟡 | Remplacer par **OpenJDK** (`openjdk-17` / `openjdk-21`, ou `openjdk-8` si un vieux logiciel l'exige). |
| **CharisSIL / Doulos / Phonetic Keyboard / fonts IPA** | 🟢 | Polices SIL disponibles pour Linux (paquets `fonts-sil-charis`, `fonts-sil-doulos` ou téléchargement SIL). Saisie API : **ibus-table** / disposition clavier X11 dédiée. |
| **CLAN / ELAN-TOOLS / VizLing-master** | 🟢 | Outils multiplateformes / scripts. |

> **Bilan** : quasiment toute la chaîne de recherche est native Linux. Aucun blocage
> sérieux de ce côté. Le principal soin : exporter les listes de packages R et les
> environnements conda **avant** l'effacement.

---

## 4. Navigateurs & communication

| Logiciel | Statut | Détail |
|---|---|---|
| **Firefox** | 🟢 | Natif (souvent préinstallé). Activer la synchro compte Mozilla avant migration. |
| **Google Chrome** | 🟢 | `.deb`/`.rpm` officiels. Ou **Chromium**. Synchro via compte Google. |
| **Opera** | 🟢 | `.deb`/`.rpm` officiels. |
| **Discord** | 🟢 | Natif (`.deb` / Flatpak). |
| **Signal Desktop** | 🟢 | Natif (dépôt APT officiel / Flatpak). Historique non transféré : **relier** depuis le téléphone. |
| **Zoom** | 🟢 | Client Linux officiel. |
| **Microsoft Teams** | 🌐 / 🟡 | Plus de client Linux natif Microsoft → **version web** (Chrome/Edge), ou clients tiers (**Teams for Linux**, non officiel). |
| **Skype** | 🔴 | Client Linux abandonné + Skype ferme en 2025. Migrer vers Teams/autre. |
| **Zoom Workplace / Teams add-in Office** | — | Sans objet sous Linux. |
| **HonorSuite / Quick Share (Google)** | 🟡 | Transfert de fichiers avec le téléphone : **KDE Connect** (🟢, excellent, Android + iOS partiel), **GSConnect** (extension GNOME), **LocalSend**. |
| **iCloud pour Windows** | 🌐 | Web uniquement (icloud.com). |

---

## 5. Multimédia (lecture, montage, capture)

| Logiciel | Statut | Détail |
|---|---|---|
| **VLC 3.0** | 🟢 | Natif. Alternative : **mpv**. |
| **BS.Player** | 🟡 | → VLC / mpv. |
| **DaVinci Resolve** (Panels, Keyboards, BRAW) | 🟢 | **Version Linux officielle** Blackmagic. Bien avec NVIDIA. (Import de certains codecs `.mp4/AAC` : parfois installer les paquets non libres, ou passer par un conteneur.) |
| **ScreenToGif** | 🔴 / 🟡 | Windows uniquement. Équivalents : **Peek**, **Kooha**, **OBS Studio**, `wf-recorder`. |
| **PrtScr / capture d'écran** | 🟡 | **Flameshot** (🟢, excellent), **Spectacle** (KDE), **GNOME Screenshot**. |
| **balenaEtcher** | 🟢 | Natif Linux (AppImage). Sert justement à créer la clé USB. |
| **HP Deskjet 3050A (pilotes/logiciel)** | 🟢 | Sous Linux : **CUPS** + **HPLIP** (paquet `hplip`) → imprimante + scan reconnus automatiquement. |

---

## 6. Utilitaires système & fichiers

| Logiciel | Statut | Détail |
|---|---|---|
| **WinRAR / 7-Zip** | 🟡 | **Ark** (KDE) / **File Roller** (GNOME) + `p7zip`, `unrar`, `unar`. Gèrent zip/7z/rar/tar. |
| **CCleaner** | 🟡 | Inutile sous Linux en général. Si besoin : **BleachBit**, `sudo apt autoremove`, `journalctl --vacuum`. |
| **CClamAV / ClamAV** | 🟢 | `clamav` natif. Antivirus rarement nécessaire sous Linux desktop. |
| **McAfee WebAdvisor / DriverHub** | 🔴 | À ne pas réinstaller (bloatware). Les pilotes sont dans le noyau. |
| **Everything (recherche fichiers)** | 🟡 | `plocate` (`locate`), **FSearch** (GUI, très proche d'Everything), **Catfish**. |
| **Notepad++** | 🟡 | **Notepadqq**, **Kate**, **Geany**, **VS Code**, ou **Sublime Text** (🟢 natif Linux). |
| **Sublime Text 3** | 🟢 | Version Linux officielle (dépôt APT). |
| **Atom** | 🔴 | Projet arrêté (2022). → **VS Code** / **Pulsar** (fork communautaire d'Atom, 🟢). |
| **Java / VC++ Redistributables / .NET / XNA** | — | Sans objet : dépendances gérées par le gestionnaire de paquets (`openjdk`, `mono`/`dotnet` si besoin). |
| **Patriot Viper RGB / Holtek RGB / AURA** | 🟡 | **OpenRGB** (support partiel). |
| **iCloud / OneDrive** | 🌐 / 🟡 | OneDrive : **abraunegg/onedrive** (client CLI natif, fiable) ou **rclone**. iCloud : web. |

---

## 7. Développement

| Logiciel | Statut | Détail |
|---|---|---|
| **Git 2.28** | 🟢 | `apt install git` (version bien plus récente). |
| **GitHub Desktop** | 🟡 | Pas de version Linux officielle. **GitHub CLI** (`gh`, 🟢), **git-cola**, **GitKraken** (🟢), **Lazygit**, ou le fork communautaire **github-desktop (shiftkey)**. |
| **RStudio / R** | 🟢 | Natifs. |
| **Anaconda / Python** | 🟢 | Natifs. |
| **Google Cloud SDK (`gcloud`, `gsutil`)** | 🟢 | Natif Linux. |
| **Sublime / VS Code / Notepad++** | voir §6 | |

---

## 8. Cloud & synchronisation (récap)

| Service | Client Linux | Recommandation |
|---|---|---|
| **Google Drive** | 🔴 (aucun officiel) | **rclone** (gratuit) ou **Insync** (payant, GUI) ou navigateur. |
| **Nextcloud** | 🟢 | Client officiel Linux — réinstallation directe. |
| **OneDrive** | 🟡 | `abraunegg/onedrive` (CLI) ou rclone. |
| **iCloud** | 🔴 | Web uniquement. |
| **Dropbox** (si utilisé) | 🟢 | Client officiel Linux. |

---

## 9. Jeux (pour mémoire — non sauvegardés)

- **Steam** : 🟢 client Linux officiel. **Proton** (couche de compatibilité intégrée) fait
  tourner l'immense majorité de votre ludothèque (jeux indés notamment : Hades, Hollow
  Knight, Celeste-like, Dead Cells, Disco Elysium… tous « Playable »/« Verified »).
  Vérifiable sur **protondb.com**.
- **Minecraft** : 🟢 lanceur natif (Java).
- **Rockstar Games Launcher / FFXIV / Paradox** : 🍷 via Proton/Lutris, résultats variables
  (les DRM et anti-triche en ligne peuvent bloquer).
- Rien à sauvegarder : tout se retéléécharge via les comptes Steam/Rockstar/Mojang.
