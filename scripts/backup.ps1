<#
    backup.ps1 — Sauvegarde non destructive des données essentielles du SSD
    avant effacement et installation de Linux.

    Machine : ASUS ROG Strix GL10DH   —   Cible : D:\BACKUP-PC-2026-09\

    UTILISATION (PowerShell, dans le dossier du projet) :

        # 1) Sauvegarde réelle
        .\scripts\backup.ps1

        # 2) Vérification : liste ce qui différerait encore (doit être quasi vide)
        .\scripts\backup.ps1 -Verify

        # Personnaliser la destination :
        .\scripts\backup.ps1 -Destination "E:\BACKUP-PC-2026-09"

    NOTES
    - robocopy est utilisé SANS /MIR : rien n'est jamais supprimé sur la destination.
    - /XJ : ignore les jonctions (évite les boucles dans AppData).
    - /COPY:DAT : copie données + attributs + horodatage (pas les ACL → pas d'erreurs
      de permissions sur un disque externe).
    - Relançable : robocopy saute ce qui est déjà copié et identique.
#>

[CmdletBinding()]
param(
    [string]$Destination = "D:\BACKUP-PC-2026-09",
    [switch]$Verify
)

$ErrorActionPreference = "Stop"
$user = $env:USERPROFILE

# --- Liste des sauvegardes : Nom, Source, Sélecteur de fichiers (vide = tout) ---
$jobs = @(
    @{ Name = "Downloads";              Src = "$user\Downloads" }
    @{ Name = "Documents";              Src = "$user\Documents" }
    @{ Name = "Pictures";               Src = "$user\Pictures" }
    @{ Name = "Desktop";                Src = "$user\Desktop" }
    @{ Name = "Vieux-telechargements";  Src = "E:\Vieux téléchargements" }

    # Profils navigateurs / applis (secours ; l'idéal reste la synchro de compte)
    @{ Name = "Firefox-profil";  Src = "$env:APPDATA\Mozilla\Firefox" }
    @{ Name = "Chrome-profil";   Src = "$env:LOCALAPPDATA\Google\Chrome\User Data";
       Xd  = @("Cache","Code Cache","GPUCache","Service Worker","GrShaderCache") }
    @{ Name = "Opera-profil";    Src = "$env:APPDATA\Opera Software" }
    @{ Name = "Signal";          Src = "$env:APPDATA\Signal";
       Xd  = @("logs") }
    @{ Name = "Zotero";          Src = "$user\Zotero" }
)

# Fichiers isolés à copier tels quels
$looseFiles = @(
    "$user\.gitconfig"
)

# --- Préparation ---
$logDir = Join-Path $Destination "_logs"
if (-not $Verify) {
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    New-Item -ItemType Directory -Force -Path $logDir      | Out-Null
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$mode  = if ($Verify) { "VÉRIFICATION (aucune écriture)" } else { "SAUVEGARDE" }
Write-Host "=== $mode  ->  $Destination ===" -ForegroundColor Cyan
Write-Host ""

$summary = @()

foreach ($j in $jobs) {
    $src = $j.Src
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Host ("[SKIP] {0,-22} source absente : {1}" -f $j.Name, $src) -ForegroundColor DarkYellow
        $summary += [pscustomobject]@{ Job = $j.Name; Etat = "absent"; Src = $src }
        continue
    }

    $dst  = Join-Path $Destination $j.Name
    $args = @($src, $dst, "/E", "/COPY:DAT", "/DCOPY:DAT", "/XJ", "/R:2", "/W:5", "/MT:16", "/NP", "/NDL")

    if ($j.Xd)      { foreach ($d in $j.Xd) { $args += @("/XD", (Join-Path $src $d)) } }
    if ($Verify)    { $args += "/L" }
    $log  = Join-Path $logDir ("{0}_{1}{2}.log" -f $j.Name, $stamp, ($(if($Verify){"_verify"}else{""})))
    $args += "/LOG:$log"
    $args += "/TEE"

    Write-Host ("[ {0} ] {1}" -f $j.Name, $src) -ForegroundColor Green
    robocopy @args | Out-Null
    $rc = $LASTEXITCODE   # robocopy : <8 = OK

    $srcStat = Get-ChildItem -LiteralPath $src -Recurse -File -Force -ErrorAction SilentlyContinue |
               Measure-Object -Property Length -Sum
    $dstStat = if (Test-Path -LiteralPath $dst) {
                   Get-ChildItem -LiteralPath $dst -Recurse -File -Force -ErrorAction SilentlyContinue |
                   Measure-Object -Property Length -Sum
               } else { $null }

    $summary += [pscustomobject]@{
        Job        = $j.Name
        Etat       = if ($rc -lt 8) { "ok (rc=$rc)" } else { "ERREUR (rc=$rc)" }
        SrcFichiers = $srcStat.Count
        SrcGo       = [math]::Round(($srcStat.Sum/1GB), 2)
        DstFichiers = $dstStat.Count
        DstGo       = if ($dstStat) { [math]::Round(($dstStat.Sum/1GB), 2) } else { 0 }
    }
}

# --- Fichiers isolés ---
if (-not $Verify) {
    $dotDir = Join-Path $Destination "_dotfiles"
    New-Item -ItemType Directory -Force -Path $dotDir | Out-Null
    foreach ($f in $looseFiles) {
        if (Test-Path -LiteralPath $f) {
            Copy-Item -LiteralPath $f -Destination $dotDir -Force
            Write-Host ("[ fichier ] {0}" -f $f) -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "=== Récapitulatif ===" -ForegroundColor Cyan
$summary | Format-Table -AutoSize

$errs = $summary | Where-Object { $_.Etat -like "ERREUR*" }
if ($errs) {
    Write-Host "`n⚠️  Des tâches ont renvoyé une erreur — voir les journaux dans $logDir" -ForegroundColor Red
} elseif ($Verify) {
    Write-Host "`nVérification terminée. Ouvrez les *_verify.log : ils doivent lister très peu de fichiers 'New File'." -ForegroundColor Yellow
} else {
    Write-Host "`n✅ Sauvegarde terminée. Journaux : $logDir" -ForegroundColor Green
    Write-Host "   Étape suivante : .\scripts\backup.ps1 -Verify" -ForegroundColor Green
}
