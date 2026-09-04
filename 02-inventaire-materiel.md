# Inventaire matériel — ASUS ROG Strix GL10DH

Relevé le 2026-09-04 sur la machine (Windows 11 Famille, build 22631).

## Résumé

| Composant | Modèle | Support Linux |
|---|---|---|
| Carte mère / châssis | ASUSTeK ROG Strix GL10DH_GL10DH (tour) | — |
| Firmware | UEFI (AMI), **Secure Boot ACTIVÉ** | OK (distros signées) |
| CPU / APU | **AMD Ryzen 5 3400G** (Zen+, « Picasso »), 4 cœurs / 8 threads, 4,1 GHz | Excellent (noyau ≥ 5.4) |
| iGPU | Radeon RX Vega 11 (intégré au 3400G) | Excellent (`amdgpu`) |
| GPU dédié | **NVIDIA GeForce GTX 1660** (TU116, Turing) — `10DE:2184` | Bon, pilote propriétaire requis |
| RAM | 16 Go (2× modules) | — |
| SSD système | **WD PC SN520 SDAPNUW-256G** — NVMe M.2, 238 Go → *cible de l'installation Linux* | Excellent |
| Disque de données | Toshiba DT01ACA100 — 1 To SATA — `E:` « DATA », 268 Go libres | Excellent — **reste branché** ; on le protège en ne le cochant pas dans l'installateur |
| Disque externe | WD My Passport 07A8 — USB, 465 Go — `D:` « Cimade - CRA de Rennes », 291 Go libres | *cible de la sauvegarde* |
| Wi-Fi | **Realtek RTL8822CE** 802.11ac + Bluetooth (combo M.2) — `10EC:C822` | ⚠️ Point sensible — voir ci-dessous |
| Ethernet | Realtek RTL8111/8168 Gigabit — `10EC:8168` | OK d'origine (`r8169`) |
| Audio | Realtek **ALC887** (`10EC:0887`) + audio HDMI NVIDIA | OK d'origine (`snd_hda_intel`) |
| Bluetooth | Intégré au combo RTL8822CE (annoncé « Broadcom » côté pile BT Windows) | OK (`btrtl`), coexistence Wi-Fi parfois capricieuse |

## Points sensibles pour les pilotes

### 1. Wi-Fi Realtek RTL8822CE — le principal risque

C'est le composant historiquement problématique sur cette tour.

- Pilote noyau : `rtw88_8822ce` (module `rtw88`).
- Sur noyau **< 6.2** : déconnexions fréquentes, débit faible, coupures Bluetooth.
- Sur noyau **6.6+** : nettement mieux ; **6.8+** : globalement stable.
- La distribution recommandée doit donc embarquer un **noyau récent** (voir `04-choix-distribution-linux.md`).

**Si le Wi-Fi reste instable après installation**, dans l'ordre :

1. Brancher un **câble Ethernet** (fonctionne d'office) le temps de régler le reste.
2. Installer le pilote DKMS à jour :
   - Mint / Ubuntu : `sudo apt install rtw88-dkms`
   - sinon compiler depuis `https://github.com/lwfinger/rtw88`
3. Désactiver l'ASPM (économie d'énergie PCIe) qui cause des coupures :
   ```
   echo "options rtw88_pci disable_aspm=1" | sudo tee /etc/modprobe.d/rtw88.conf
   sudo update-initramfs -u   # (Debian/Ubuntu/Mint)  —  ou  sudo dracut -f  (Fedora)
   ```
4. Si Wi-Fi + Bluetooth se gênent : désactiver la coexistence BT ou le Bluetooth si inutilisé.

**Solution radicale recommandée (~15–20 €)** : remplacer la carte M.2 2230 Wi-Fi par une
**Intel AX210** (Wi-Fi 6E + BT 5.3). Support Linux parfait, sans configuration.
Sur une tour ASUS c'est une opération de 5 minutes (un panneau latéral, une vis M.2,
deux fils d'antenne). C'est le meilleur rapport tranquillité/prix.

### 2. NVIDIA GeForce GTX 1660 (Turing)

- Utiliser le **pilote propriétaire** `nvidia-driver-550` ou plus récent
  (le module « open » NVIDIA fonctionne aussi sur Turing).
- Le pilote libre `nouveau` fonctionne pour l'affichage mais performances faibles :
  ne pas s'en contenter.
- **Secure Boot est activé** → l'installation du pilote demande d'**enrôler une clé MOK** :
  - Mint / Ubuntu / Pop!\_OS : l'assistant le propose automatiquement
    (choisir un mot de passe, redémarrer, écran bleu « MOK Manager » → *Enroll MOK* → mot de passe).
  - Fedora : étape manuelle documentée (RPM Fusion + `akmods` + `mokutil --import`).
- En cas d'écran noir au premier démarrage (avant installation du pilote) :
  au menu de démarrage, éditer la ligne de boot et ajouter `nomodeset`.
- Alternative si vous ne voulez aucune configuration : **Pop!\_OS** propose une image ISO
  avec le pilote NVIDIA déjà intégré.

### 3. CPU/iGPU AMD Ryzen 5 3400G + Vega 11

Aucun problème. Support mature dans `amdgpu` depuis longtemps.
Le microcode AMD est fourni par le paquet `amd64-microcode` / `linux-firmware`.

### 4. Audio Realtek ALC887

Fonctionne d'office. Les distributions récentes utilisent **PipeWire**
(bon pour l'audio « pro » à faible latence, voir `03-logiciels-equivalents-linux.md`).

### 5. BIOS / UEFI ASUS

- Rester en mode **UEFI** (pas Legacy/CSM).
- **Secure Boot peut rester activé** : Mint, Ubuntu, Fedora et Pop!\_OS sont signés.
- Si la clé USB n'apparaît pas au démarrage : désactiver **Fast Boot** dans le BIOS.
- Touches ASUS au démarrage : **F8** = menu de choix du disque de démarrage ;
  **Suppr** ou **F2** = entrer dans le BIOS.
- Désactiver « Fast Startup » **côté Windows** aussi avant de partitionner (évite un
  système de fichiers laissé en état incohérent).

### 6. RGB / utilitaires ASUS

- Armoury Crate, AURA, GameFirst, ROG Live Service : **pas d'équivalent officiel Linux**.
- Éclairage RGB : `OpenRGB` gère une partie des contrôleurs ASUS Aura (résultat variable).
- Ces utilitaires ne sont pas nécessaires au fonctionnement de la machine.

## Disques — schéma actuel

```
nvme0n1  WD SN520 NVMe   238 Gio  →  C: OS (Windows, 3,9 Go libres !) + EFI + Recovery  ← À EFFACER puis Linux
sda      Toshiba 1 To SATA  931 Gio →  E: DATA (268 Go libres)                           ← RESTE BRANCHÉ, NE PAS COCHER dans l'installateur
sdb      WD My Passport USB 465 Gio →  D: « Cimade - CRA de Rennes » (291 Go libres)     ← CIBLE SAUVEGARDE, débrancher (câble USB) pendant l'install
```

> ⚠️ **Le SSD système n'a que 3,9 Go libres.** La sauvegarde ne peut pas se faire dessus.
> Elle va sur le disque externe `D:`.

> ✅ **Sécurité anti-erreur de partitionnement, sans ouvrir la tour** :
> 1. Débrancher le câble USB du disque externe `D:` (rien à ouvrir).
> 2. Dans l'installateur Fedora (« Destination de l'installation »), **cocher uniquement
>    `WDC PC SN520` (~238 Gio)** et **laisser `TOSHIBA … DT01ACA100` (~931 Gio, `DATA`)
>    décoché**. Anaconda ne partitionne que les disques cochés.
> 3. Sur l'écran de résumé, vérifier que seul `nvme0n1` est marqué « formaté / effacé ».
>
> Le débranchement physique du Toshiba n'est qu'une paranoïa optionnelle, pas une
> obligation. Détail complet dans `01-plan-backup.md` §6.
