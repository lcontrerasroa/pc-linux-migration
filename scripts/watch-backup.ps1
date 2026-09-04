<#
    watch-backup.ps1 - Barre de progression pour la sauvegarde (backup.ps1).

    A LANCER DANS TA PROPRE FENETRE PowerShell (pas via Claude) => zero token :

        powershell -ExecutionPolicy Bypass -File C:\Users\cyber\github\pc-linux-migration\scripts\watch-backup.ps1

    Lecture seule. Ctrl+C ferme l'affichage sans arreter la sauvegarde.
    S'arrete tout seul quand plus aucun robocopy ne tourne.

    Methode : la progression globale est deduite de l'ESPACE LIBRE qui diminue sur D:
    (1 seul appel systeme, insensible aux chemins longs / permissions). L'etat par
    dossier est lu dans les journaux robocopy (D:\BACKUP-PC-2026-09\_logs).
#>

param(
    [string]$Path        = "D:\BACKUP-PC-2026-09",
    [double]$StartFreeGB = 291.9,   # espace libre de D: AVANT le lancement de backup.ps1
    [int]$IntervalSec    = 5
)

$driveLetter = ($Path.Substring(0,1))

# Ordre des taches = ordre de backup.ps1, avec taille attendue (Go)
$jobs = [ordered]@{
    "_PRIORITAIRE-Adrien"   = 15.83
    "Downloads"             = 38.98
    "Documents"             = 2.46
    "Pictures"              = 9.52
    "Desktop"               = 22.78
    "iCloudDrive"           = 0.07
    "Vieux-telechargements" = 36.68
}
$totalExpected = ($jobs.Values | Measure-Object -Sum).Sum
$logDir = Join-Path $Path "_logs"

function Get-FreeGB {
    try { return [math]::Round((Get-Volume -DriveLetter $driveLetter -ErrorAction Stop).SizeRemaining / 1GB, 2) }
    catch { return $null }
}

# Un job est termine si son journal contient la ligne de resume "Octets :" / "Bytes :"
function Get-JobState([string]$name, [string]$newestLogName) {
    $lg = Get-ChildItem (Join-Path $logDir "$name`_*.log") -ErrorAction SilentlyContinue |
          Sort-Object LastWriteTime | Select-Object -Last 1
    if (-not $lg) { return @{ State = "attente"; Log = $null } }
    $tail = Get-Content $lg.FullName -Tail 15 -ErrorAction SilentlyContinue
    if ($tail -match '^\s*(Octets|Bytes)\s*:') { return @{ State = "fini"; Log = $lg } }
    if ($lg.Name -eq $newestLogName)           { return @{ State = "cours"; Log = $lg } }
    return @{ State = "attente"; Log = $lg }
}

Write-Host "Surveillance de $Path" -ForegroundColor Cyan
Write-Host ("Espace libre initial : {0:N1} Go   |   a copier : {1:N1} Go   |   refresh {2}s" -f $StartFreeGB, $totalExpected, $IntervalSec) -ForegroundColor Cyan
Write-Host "Ctrl+C = ferme l'affichage seulement.`n" -ForegroundColor DarkGray

# Amorce : evite un debit aberrant au premier affichage
$f0 = Get-FreeGB
$prevCopied = if ($f0 -ne $null) { [math]::Max($StartFreeGB - $f0, 0) } else { 0.0 }
$prevTime   = Get-Date
$missRobocopy = 0

try {
    while ($true) {
        $now  = Get-Date
        $free = Get-FreeGB
        $copied = if ($free -ne $null) { [math]::Max($StartFreeGB - $free, 0) } else { $prevCopied }

        $elapsed = ($now - $prevTime).TotalSeconds
        $rateMB  = if ($elapsed -gt 0) { (($copied - $prevCopied) * 1024) / $elapsed } else { 0 }
        $remain  = [math]::Max($totalExpected - $copied, 0)
        $etaTxt  = if ($rateMB -gt 1) { [TimeSpan]::FromSeconds([int](($remain * 1024) / $rateMB)).ToString("hh\:mm\:ss") } else { "..." }
        $pct     = [math]::Min([math]::Round($copied / $totalExpected * 100, 1), 100)

        # journal le plus recent = job en cours
        $newest = Get-ChildItem (Join-Path $logDir "*.log") -ErrorAction SilentlyContinue |
                  Sort-Object LastWriteTime | Select-Object -Last 1
        $newestName = if ($newest) { $newest.Name } else { "" }

        Write-Progress -Activity ("Sauvegarde -> {0}" -f $Path) `
            -Status ("{0:N1} / {1:N1} Go   {2}%   {3:N0} Mo/s   ETA {4}" -f $copied, $totalExpected, $pct, $rateMB, $etaTxt) `
            -PercentComplete $pct

        $stamp = "[{0:HH:mm:ss}]" -f $now
        Write-Host ("{0} {1,5:N1}% | {2,6:N1}/{3:N1} Go | {4,4:N0} Mo/s | ETA {5}" -f `
            $stamp, $pct, $copied, $totalExpected, $rateMB, $etaTxt) -ForegroundColor Green

        foreach ($name in $jobs.Keys) {
            $st = Get-JobState $name $newestName
            switch ($st.State) {
                "fini"    { Write-Host ("   [x] {0}" -f $name) -ForegroundColor DarkGray }
                "cours"   {
                    $last = if ($st.Log) { (Get-Content $st.Log.FullName -Tail 1 -ErrorAction SilentlyContinue) } else { "" }
                    $last = ($last -replace '\s+', ' ').Trim()
                    if ($last.Length -gt 90) { $last = $last.Substring($last.Length - 90) }
                    Write-Host ("   [>] {0}  (attendu {1:N1} Go)" -f $name, $jobs[$name]) -ForegroundColor Yellow
                    if ($last) { Write-Host ("        $last") -ForegroundColor DarkYellow }
                }
                default   { Write-Host ("   [ ] {0}" -f $name) -ForegroundColor DarkGray }
            }
        }

        if (@(Get-Process robocopy -ErrorAction SilentlyContinue).Count -gt 0) { $missRobocopy = 0 }
        else { $missRobocopy++ }

        if ($missRobocopy -ge 3) {
            Write-Progress -Activity "Sauvegarde" -Completed
            Write-Host "`n=== Plus aucun robocopy actif : sauvegarde terminee ===" -ForegroundColor Yellow
            Write-Host ("Copie totale (delta espace libre) : {0:N1} Go" -f $copied) -ForegroundColor Yellow
            Write-Host ("Verification :  powershell -ExecutionPolicy Bypass -File {0}\backup.ps1 -Verify" -f $PSScriptRoot) -ForegroundColor Yellow
            break
        }

        Write-Host ""
        $prevCopied = $copied
        $prevTime   = $now
        Start-Sleep -Seconds $IntervalSec
    }
}
finally {
    Write-Progress -Activity "Sauvegarde" -Completed
}
