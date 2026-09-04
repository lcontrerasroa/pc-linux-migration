<#
    backup.ps1 - Sauvegarde non destructive des donnees essentielles du SSD
    avant effacement et installation de Linux.

    Machine : ASUS ROG Strix GL10DH   -   Cible par defaut : D:\BACKUP-PC-2026-09\

    UTILISATION (PowerShell) :

        # 1) Sauvegarde reelle (relançable : ne recopie que ce qui manque / a change)
        powershell -ExecutionPolicy Bypass -File .\scripts\backup.ps1

        # 2) Verification : liste ce qui differerait encore (colonne "a copier" doit etre ~0)
        powershell -ExecutionPolicy Bypass -File .\scripts\backup.ps1 -Verify

        # Destination personnalisee :
        .\scripts\backup.ps1 -Destination "E:\BACKUP-PC-2026-09"

    NOTES
    - robocopy SANS /MIR : rien n'est jamais supprime sur la destination.
    - /XJ : ignore les jonctions (evite les boucles dans AppData).
    - /COPY:DAT : donnees + attributs + horodatage (pas les ACL -> pas d'erreurs de
      permissions sur un disque externe).
    - Le recapitulatif est lu DANS LES JOURNAUX robocopy (insensible aux chemins > 260
      caracteres, contrairement a un parcours Get-ChildItem).
    - Fichiers "cloud only" (iCloud Photos non telecharges, OneDrive a la demande...) :
      robocopy ne peut pas les materialiser -> ils apparaissent en ECHEC. Il faut
      d'abord forcer leur telechargement local, puis relancer ce script.
#>

[CmdletBinding()]
param(
    [string]$Destination = "D:\BACKUP-PC-2026-09",
    [switch]$Verify
)

$ErrorActionPreference = "Continue"   # un script de sauvegarde ne doit pas s'arreter a la 1re erreur
$user = $env:USERPROFILE

# --- Taches : Nom, Source, exclusions de dossiers (Xd) ---  L'ordre compte (prioritaires d'abord).
$jobs = @(
    # >>> PRIORITE ABSOLUE : copie dediee du dossier Adrien (aussi inclus dans Desktop).
    @{ Name = "_PRIORITAIRE-Adrien";   Src = "$user\Desktop\Adrien" }

    @{ Name = "Downloads";              Src = "$user\Downloads" }
    @{ Name = "Documents";              Src = "$user\Documents" }
    @{ Name = "Pictures";               Src = "$user\Pictures" }
    @{ Name = "Desktop";                Src = "$user\Desktop" }
    @{ Name = "iCloudDrive";            Src = "$user\iCloudDrive" }
    @{ Name = "Vieux-telechargements";  Src = "E:\Vieux téléchargements" }

    # Profils navigateurs / applis (secours ; l'ideal reste la synchro de compte).
    # Fermer Chrome / Signal avant de lancer pour eviter les fichiers verrouilles.
    @{ Name = "Firefox-profil";  Src = "$env:APPDATA\Mozilla\Firefox" }
    @{ Name = "Chrome-profil";   Src = "$env:LOCALAPPDATA\Google\Chrome\User Data";
       Xd  = @("Cache","Code Cache","GPUCache","Service Worker","GrShaderCache") }
    @{ Name = "Opera-profil";    Src = "$env:APPDATA\Opera Software" }
    @{ Name = "Signal";          Src = "$env:APPDATA\Signal"; Xd = @("logs") }
    @{ Name = "Zotero";          Src = "$user\Zotero" }
)

$looseFiles = @( "$user\.gitconfig" )

# --- Preparation ---
$logDir = Join-Path $Destination "_logs"
if (-not (Test-Path -LiteralPath $Destination)) {
    if ($Verify) { Write-Host "Destination introuvable : $Destination" -ForegroundColor Red; exit 2 }
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
}
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$mode  = if ($Verify) { "VERIFICATION (aucune ecriture)" } else { "SAUVEGARDE" }
Write-Host "=== $mode  ->  $Destination ===" -ForegroundColor Cyan
Write-Host ""

# Lit les lignes de resume d'un log robocopy (FR ou EN). Renvoie un hashtable.
function Read-RobocopySummary([string]$logPath) {
    $res = @{ FTotal = $null; FCopies = $null; FEchec = $null; FIgnores = $null; BytesCopie = ""; CloudErr = 0; OtherErr = 0 }
    if (-not (Test-Path -LiteralPath $logPath)) { return $res }
    $lines = Get-Content -LiteralPath $logPath -ErrorAction SilentlyContinue
    foreach ($ln in $lines) {
        if ($ln -match '^\s*(Fichiers|Files)\s*:\s*(.+)$') {
            $nums = [regex]::Matches($matches[2], '\d[\d.,]*') | ForEach-Object { [int64]($_.Value -replace '[.,]','') }
            if ($nums.Count -ge 5) { $res.FTotal=$nums[0]; $res.FCopies=$nums[1]; $res.FIgnores=$nums[2]; $res.FEchec=$nums[4] }
        }
        elseif ($ln -match '^\s*(Octets|Bytes)\s*:\s*(.+)$') {
            $parts = ($matches[2] -replace '\s{2,}',' ').Trim() -split ' '
            # positions : Total Copie Ignore Discordance Echec Extras (unites possibles)
            if ($parts.Count -ge 2) { $res.BytesCopie = $parts[1..([math]::Min(2,$parts.Count-1))] -join ' ' }
        }
        elseif ($ln -match 'ERREUR\s+\d+|ERROR\s+\d+') {
            if ($ln -match '0x0000018[4B]|0x000001AA|cloud|nuage') { $res.CloudErr++ } else { $res.OtherErr++ }
        }
    }
    return $res
}

$summary = @()

foreach ($j in $jobs) {
    $src = $j.Src
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Host ("[ABSENT] {0} : {1}" -f $j.Name, $src) -ForegroundColor DarkYellow
        $summary += [pscustomobject]@{ Job=$j.Name; Etat="source absente"; Total=$null; Copies=$null; Echec=$null; Octets="" }
        continue
    }

    $dst = Join-Path $Destination $j.Name
    $suffix = if ($Verify) { "_verify" } else { "" }
    $log = Join-Path $logDir ("{0}_{1}{2}.log" -f $j.Name, $stamp, $suffix)

    $rcArgs = @($src, $dst, "/E", "/COPY:DAT", "/DCOPY:DAT", "/XJ", "/R:1", "/W:3", "/MT:16", "/NP", "/NDL", "/NS")
    if ($j.Xd)   { foreach ($d in $j.Xd) { $rcArgs += @("/XD", (Join-Path $src $d)) } }
    if ($Verify) { $rcArgs += "/L" }
    $rcArgs += "/LOG:$log"

    Write-Host ("[ {0,-22} ] {1}" -f $j.Name, $src) -ForegroundColor Green
    & robocopy @rcArgs | Out-Null
    $rc = $LASTEXITCODE

    $s = Read-RobocopySummary $log
    $echec = if ($s.FEchec -ne $null) { [int]$s.FEchec } else { 0 }
    $etat =
        if ($rc -ge 16)              { "ECHEC GRAVE (rc=$rc)" }
        elseif ($echec -gt 0)        { "$echec fichier(s) non copie(s)" + $(if ($s.CloudErr -gt 0) { " [cloud only]" } else { "" }) }
        elseif ($rc -ge 8)           { "erreurs (rc=$rc)" }
        else                         { "OK" }

    $summary += [pscustomobject]@{
        Job    = $j.Name
        Etat   = $etat
        Total  = $s.FTotal
        Copies = $s.FCopies
        Echec  = $echec
        Octets = $s.BytesCopie
    }
}

# --- Fichiers isoles ---
if (-not $Verify) {
    $dotDir = Join-Path $Destination "_dotfiles"
    New-Item -ItemType Directory -Force -Path $dotDir | Out-Null
    foreach ($f in $looseFiles) {
        if (Test-Path -LiteralPath $f) {
            Copy-Item -LiteralPath $f -Destination $dotDir -Force -ErrorAction SilentlyContinue
            Write-Host ("[ fichier ] {0}" -f $f) -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "=== Recapitulatif ($mode) ===" -ForegroundColor Cyan
$summary | Format-Table -AutoSize Job, Etat, Total, Copies, Echec, Octets

$bad = $summary | Where-Object { $_.Etat -ne "OK" -and $_.Etat -ne "source absente" }
Write-Host ""
if ($bad) {
    Write-Host "[!] Taches a revoir :" -ForegroundColor Red
    $bad | ForEach-Object { Write-Host ("    - {0} : {1}" -f $_.Job, $_.Etat) -ForegroundColor Red }
    Write-Host "    Details : $logDir" -ForegroundColor Red
    Write-Host "    Fichiers 'cloud only' -> les telecharger en local puis relancer ce script (incremental)." -ForegroundColor Yellow
} elseif ($Verify) {
    Write-Host "[OK] Verification : la colonne 'Copies' doit etre ~0 partout (rien ne differe)." -ForegroundColor Green
} else {
    Write-Host "[OK] Sauvegarde terminee. Etape suivante : ... -File .\scripts\backup.ps1 -Verify" -ForegroundColor Green
}
