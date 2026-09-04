# Vérifications à lancer sous Linux après installation

À exécuter dans un terminal une fois Linux installé, pour confirmer que le matériel
est bien pris en charge.

## Noyau et distribution
```bash
uname -r                 # version du noyau (viser >= 6.8 pour le Wi-Fi)
cat /etc/os-release
```

## CPU / APU AMD
```bash
lscpu | grep -E "Model name|CPU\(s\)"
# doit afficher : AMD Ryzen 5 3400G with Radeon Vega Graphics
```

## GPU NVIDIA
```bash
lspci -k | grep -A3 -E "VGA|3D"        # voir "Kernel driver in use: nvidia"
nvidia-smi                             # doit lister GTX 1660 + version du pilote
glxinfo -B 2>/dev/null | grep -E "OpenGL renderer|OpenGL version"
```
Si `Kernel driver in use: nouveau` → le pilote propriétaire n'est pas actif :
- Mint : *Gestionnaire de pilotes* → `nvidia-driver-5xx`
- Fedora : RPM Fusion + `sudo dnf install akmod-nvidia`
- puis redémarrer et enrôler la clé MOK (Secure Boot)

## Wi-Fi Realtek RTL8822CE
```bash
lspci -k | grep -A3 -i network        # "Kernel driver in use: rtw_8822ce" ou "rtw88_8822ce"
nmcli device status
nmcli device wifi list
dmesg | grep -i -E "rtw|8822" | tail -n 30
```
Test de stabilité (laisser tourner, ne doit pas monter en flèche) :
```bash
ping -i 2 1.1.1.1
```
Si coupures / débit faible :
```bash
# Ubuntu / Mint
sudo apt install rtw88-dkms
echo "options rtw88_pci disable_aspm=1" | sudo tee /etc/modprobe.d/rtw88.conf
sudo update-initramfs -u && sudo reboot
```

## Ethernet Realtek RTL8168
```bash
lspci -k | grep -A3 -i ethernet       # "Kernel driver in use: r8169"
ip link
```

## Audio Realtek ALC887 (PipeWire)
```bash
pactl info | grep "Server Name"       # doit mentionner PipeWire
wpctl status                          # périphériques de sortie/entrée
aplay -l                              # cartes ALSA (Realtek + HDMI NVIDIA)
```
Pour la MAO (faible latence) :
```bash
sudo usermod -aG audio "$USER"
# limites temps réel
echo "@audio - rtprio 95
@audio - memlock unlimited" | sudo tee /etc/security/limits.d/audio.conf
# paquet pont JACK
sudo apt install pipewire-jack   # ou: sudo dnf install pipewire-jack-audio-connection-kit
```

## Bluetooth (combo RTL8822CE)
```bash
bluetoothctl show
dmesg | grep -i -E "bluetooth|btrtl" | tail
```

## Disques
```bash
lsblk -f
# nvme0n1  -> Linux (WD SN520)
# sda      -> ancien E: "DATA" (Toshiba, NTFS) — rebranché après install
# sdb      -> WD My Passport (sauvegarde)
```
Montage auto des disques NTFS : les environnements de bureau le proposent ;
sinon ajouter une ligne `/etc/fstab` avec `ntfs3`.

## Firmware / microcode
```bash
dmesg | grep -i -E "microcode|firmware" | grep -i -E "amd|fail" | tail
```

## Capteurs (ventilos / températures de la tour)
```bash
sudo apt install lm-sensors && sudo sensors-detect --auto && sensors
```

## RGB ASUS Aura (optionnel)
```bash
# OpenRGB — support partiel des contrôleurs Aura
sudo apt install openrgb   # ou Flatpak: org.openrgb.OpenRGB
openrgb --list-devices
```
