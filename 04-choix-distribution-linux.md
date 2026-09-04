# Choix de la distribution Linux pour l'ASUS ROG Strix GL10DH

## Contraintes issues du matériel (voir `02-inventaire-materiel.md`)

| Contrainte | Conséquence sur le choix |
|---|---|
| Wi-Fi Realtek **RTL8822CE** capricieux | Besoin d'un **noyau récent** (≥ 6.6, idéalement ≥ 6.8) |
| GPU **NVIDIA GTX 1660** (Turing) | Besoin d'une install **simple** du pilote propriétaire |
| **Secure Boot activé** | La distro doit être signée + gérer l'enrôlement MOK du pilote NVIDIA |
| APU **Ryzen 5 3400G / Vega 11** | Aucun souci sur noyau récent |
| Utilisateur « à l'aise occasionnellement » | Éviter les distros à maintenance lourde (Arch, Gentoo) |
| Intérêt MAO + recherche | PipeWire récent utile ; paquets scientifiques disponibles partout |

## Comparatif

| Distro | Noyau (2026) | Pilote NVIDIA | Wi-Fi 8822CE d'origine | Secure Boot | Pour qui | Verdict ici |
|---|---|---|---|---|---|---|
| **Linux Mint 22.x** (Cinnamon, base Ubuntu 24.04 LTS) | 6.8, HWE → 6.11+ | **1 clic** (« Gestionnaire de pilotes »), MOK guidé | Correct (6.8), bon après HWE | Oui | Débutant → intermédiaire voulant que ça marche | ✅ **Recommandé** |
| **Fedora Workstation 41/42** (GNOME ou KDE) | **6.11 → 6.13+** | RPM Fusion + `akmod-nvidia` + signature MOK (~6 commandes) | **Très bon** (noyau frais) | Oui | Intermédiaire acceptant quelques commandes | ✅ Très bon 2ᵉ choix |
| **Pop!\_OS** (System76, ISO « NVIDIA ») | 6.9 → (COSMIC 24.04 selon dispo) | **Préinstallé** dans l'ISO NVIDIA, zéro config | Correct | Oui | Zéro configuration NVIDIA | ✅ Bon si l'ISO 24.04 est stable |
| **Ubuntu 24.04 LTS** (GNOME) | 6.8, HWE → 6.11+ | « Pilotes additionnels », MOK guidé | Correct | Oui | Comme Mint, bureau GNOME | ➖ Équivalent à Mint |
| **Manjaro / EndeavourOS** (Arch) | Très récent | AUR / assistant | Très bon | Partiel | Utilisateur qui aime bidouiller | ⚠️ Maintenance trop exigeante ici |
| **Debian 12 stable** | 6.1 (trop vieux) | `non-free` | ❌ Wi-Fi problématique | Oui | Serveurs, machines simples | ❌ Noyau trop ancien pour ce Wi-Fi |
| **openSUSE Tumbleweed** | Rolling, très récent | Dépôt NVIDIA | Bon | Fiddly | Utilisateur avancé | ⚠️ NVIDIA + Secure Boot pénible |

## Recommandation

### 1er choix — **Linux Mint 22.x « Cinnamon »**

Pourquoi c'est le meilleur compromis pour cette machine **et** ce profil :

- **NVIDIA en un clic** : après installation, ouvrir *Gestionnaire de pilotes*, choisir
  `nvidia-driver-5xx` (recommandé), valider. L'assistant gère l'enrôlement MOK pour
  Secure Boot (choisir un mot de passe, redémarrer, *Enroll MOK*).
- **Base Ubuntu 24.04 LTS** → la plus grande base de tutoriels et de réponses en ligne
  (tout ce qui vaut pour Ubuntu vaut pour Mint).
- **Cinnamon** : bureau léger (bon pour la Vega 11), disposition proche de Windows,
  transition douce.
- **Noyau 6.8** suffisant pour le Wi-Fi ; si instable, installer le **noyau HWE**
  (`linux-generic-hwe-24.04`, ~6.11) via *Gestionnaire de mise à jour → Noyaux*, ou
  `rtw88-dkms`. Voir `02-inventaire-materiel.md` §1.
- **Timeshift préinstallé** : snapshots système automatiques (filet de sécurité).
- **PipeWire** par défaut → base MAO correcte.
- Support long (jusqu'en 2029).

### 2ᵉ choix — **Fedora Workstation 42** (si vous voulez le matériel le mieux géré d'origine)

- **Noyau très récent** → **meilleur support du Wi-Fi RTL8822CE et de l'APU sans rien faire**,
  Mesa/PipeWire de dernière génération (le mieux pour la latence audio).
- Contrepartie : NVIDIA demande d'activer **RPM Fusion** puis d'installer `akmod-nvidia`,
  et de **signer le module pour Secure Boot** (procédure documentée, quelques commandes ;
  ou désactiver Secure Boot dans le BIOS pour simplifier).
- Rythme de mises à jour plus soutenu (ça reste stable, mais plus « vivant » que Mint).
- Choisir l'édition **KDE Plasma** si vous voulez un bureau très configurable et proche
  Windows ; **GNOME** pour l'édition par défaut.

### 3ᵉ choix — **Pop!\_OS (ISO NVIDIA)**

- **Pilote NVIDIA déjà dans l'ISO** : rien à configurer, idéal si le point NVIDIA vous
  inquiète.
- À retenir si, au moment de l'installation, l'ISO **Pop!\_OS 24.04** est disponible et
  stable (sinon la base 22.04 commence à dater). Vérifier sur system76.com.

## Ce qu'il faut télécharger et vérifier

1. ISO depuis le **site officiel** de la distro choisie (jamais un miroir tiers douteux).
2. **Vérifier la somme de contrôle** (SHA256) affichée sur le site :
   ```powershell
   Get-FileHash -Algorithm SHA256 "$HOME\Downloads\linuxmint-22-cinnamon-64bit.iso"
   ```
   Comparer avec la valeur publiée.
3. Écrire l'ISO sur une **clé USB ≥ 8 Go** (⚠️ pas le disque de sauvegarde) :
   - **balenaEtcher** (déjà installé) — le plus simple ;
   - ou **Rufus** (mode *GPT / UEFI*, *non-CSM*).
4. La plupart des distros recommandées ont un **mode « live »** : on peut démarrer dessus
   **sans rien installer** pour tester d'abord — vérifier en particulier :
   - le **Wi-Fi** se connecte et tient la connexion,
   - l'**affichage** est net (résolution correcte),
   - le **son** sort,
   - le **pavé tactile / clavier / USB** répondent (ici tour → clavier/souris USB).

## Réglages BIOS avant installation

- Mode **UEFI** (pas Legacy / CSM).
- **Secure Boot** : peut rester **activé** (Mint / Fedora / Pop le gèrent).
  Le désactiver simplifie NVIDIA sur Fedora si besoin.
- **Fast Boot** : désactivé (sinon la clé USB peut ne pas être détectée).
- Côté Windows encore en place : désactiver **« Démarrage rapide »**
  (Panneau de configuration → Options d'alimentation) avant de toucher aux partitions.
- Ordre de démarrage : USB en premier, ou utiliser **F8** au logo ASUS.

## Partitionnement (install sur le SSD NVMe uniquement)

- Cible : **WD PC SN520, 238 Go** (le seul disque restant si vous avez débranché le Toshiba).
- Schéma simple conseillé pour un usage bureautique/recherche :
  - `EFI` : 512 Mo (FAT32, `/boot/efi`) — l'installateur le crée
  - `/` (racine) : tout le reste, en **ext4** (ou **btrfs** si vous voulez les snapshots —
    Fedora le fait par défaut)
  - **swap** : fichier d'échange de 8–16 Go (les installateurs modernes le gèrent seuls ;
    pas besoin de partition dédiée avec 16 Go de RAM)
- Option « Effacer le disque et installer » = OK **puisque le Toshiba est débranché**.
  Sinon, choisir « Autre chose » / manuel et sélectionner explicitement le SN520.

## Après installation → voir `05-checklist-execution.md`
