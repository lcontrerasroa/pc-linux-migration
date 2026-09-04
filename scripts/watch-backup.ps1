<#
    watch-backup.ps1 - Barre de progression pour la sauvegarde en cours.

    A LANCER DANS TA PROPRE FENETRE PowerShell (pas via Claude), donc zero token :

        powershell -ExecutionPolicy Bypass -File C:\Users\cyber\github\pc-linux-migration\scripts\watch-backup.ps1

    - N'ecrit rien, ne modifie rien : lecture seule.
    - Ctrl+C ferme juste l'affichage, ca n'arrete PAS la sauvegarde.
    - Se termine tout seul quand plus aucun robocopy ne tourne.

    Optimisation : chaque sous-dossier termine est "gele" et n'est plus reparcouru,
    pour ne pas gener la sauvegarde en cours.
#>

param(
    [string]$Path = "D:\BACKUP-PC-2026-09",
    [int]$IntervalSec = 15
)

# Tailles attendues par tache (Go), d'apres le releve initial
$expected = [ordered]@{
    "_PRIORITAIRE-Adrien"   = 15.83
    "Downloads"             = 38.98
    "Documents"             = 2.46
    "Pictures"              = 9.52
    "Desktop"               = 22.78
    "iCloudDrive"           = 0.07
    "Vieux-telechargements" = 36.68
}
$totalExpected = ($expected.Values | Measure-Object -Sum).Sum
$frozen = @{}   # nom -> taille Go figee une fois la tache finie

function Get-DirGB([string]$p) {
    if (-not (Test-Path -LiteralPath $p)) { return 0.0 }
    $sum = [int64]0
    try {
        foreach ($f in [System.IO.Directory]::EnumerateFiles($p, '*', [System.IO.SearchOption]::AllDirectories)) {
            try { $sum += ([System.IO.FileInfo]::new($f)).Length } catch {}
        }
    } catch {}
    return [math]::Round($sum / 1GB, 2)
}

Write-Host "Surveillance de $Path" -ForegroundColor Cyan
Write-Host ("Cible totale estimee : {0:N1} Go   (rafraichissement {1}s)" -f $totalExpected, $IntervalSec) -ForegroundColor Cyan
Write-Host "Ctrl+C = ferme l'affichage seulement.`n" -ForegroundColor DarkGray

$prevTotal = 0.0
$prevTime  = Get-Date
$missRobocopy = 0

try {
    while ($true) {
        $now = Get-Date

        # Tailles actuelles (les dossiers figes ne sont plus reparcourus)
        $keys = @($expected.Keys)
        $sizes = @{}
        for ($i = 0; $i -lt $keys.Count; $i++) {
            $k = $keys[$i]
            if ($frozen.ContainsKey($k)) { $sizes[$k] = $frozen[$k] }
            else { $sizes[$k] = Get-DirGB (Join-Path $Path $k) }
        }
        # robocopy traite les taches dans l'ordre : si une tache suivante a demarre,
        # les precedentes sont terminees -> on les fige.
        for ($i = 0; $i -lt $keys.Count - 1; $i++) {
            $laterStarted = $false
            for ($j = $i + 1; $j -lt $keys.Count; $j++) { if ($sizes[$keys[$j]] -gt 0.05) { $laterStarted = $true; break } }
            if ($laterStarted -and -not $frozen.ContainsKey($keys[$i])) { $frozen[$keys[$i]] = $sizes[$keys[$i]] }
        }

        $curTotal = 0.0
        $lines = @()
        foreach ($k in $keys) {
            $e = $expected[$k]; $g = $sizes[$k]
            $curTotal += $g
            $p2  = if ($e -gt 0) { [math]::Min([int]($g / $e * 100), 100) } else { 100 }
            $bar = ("#" * [int]($p2 / 5)).PadRight(20)
            $mk  = if ($frozen.ContainsKey($k) -or $p2 -ge 100) { "OK" } else { "  " }
            $lines += ("  {0} [{1}] {2,3}%  {3,6:N1} / {4,-5:N1} Go  {5}" -f $mk, $bar, $p2, $g, $e, $k)
        }

        $elapsed = ($now - $prevTime).TotalSeconds
        $rateMB  = if ($elapsed -gt 0) { (($curTotal - $prevTotal) * 1024) / $elapsed } else { 0 }
        $remain  = [math]::Max($totalExpected - $curTotal, 0)
        $etaTxt  = if ($rateMB -gt 0.5) {
                       [TimeSpan]::FromSeconds([int](($remain * 1024) / $rateMB)).ToString("hh\:mm\:ss")
                   } else { "..." }
        $pct = [math]::Min([math]::Round($curTotal / $totalExpected * 100, 1), 100)

        Write-Progress -Activity "Sauvegarde -> $Path" `
            -Status ("{0:N1} / {1:N1} Go   {2:N0} Mo/s   ETA {3}" -f $curTotal, $totalExpected, $rateMB, $etaTxt) `
            -PercentComplete $pct

        Clear-Host
        Write-Host ("[{0:HH:mm:ss}]  {1:N1} / {2:N1} Go   {3}%   {4:N0} Mo/s   ETA {5}" -f `
            $now, $curTotal, $totalExpected, $pct, $rateMB, $etaTxt) -ForegroundColor Green
        Write-Host ""
        $lines | ForEach-Object { Write-Host $_ }

        $rc = @(Get-Process robocopy -ErrorAction SilentlyContinue)
        if ($rc.Count -gt 0) {
            $missRobocopy = 0
            Write-Host "`n  robocopy actif ($($rc.Count) processus)" -ForegroundColor DarkGray
        } else {
            $missRobocopy++
            Write-Host "`n  (aucun robocopy actif - $missRobocopy)" -ForegroundColor DarkYellow
        }

        if ($missRobocopy -ge 3) {
            Write-Progress -Activity "Sauvegarde" -Completed
            Write-Host "`n=== Sauvegarde terminee (plus aucun robocopy) ===" -ForegroundColor Yellow
            Write-Host ("Total ecrit : {0:N1} Go" -f $curTotal) -ForegroundColor Yellow
            Write-Host "Etape suivante :  powershell -ExecutionPolicy Bypass -File $PSScriptRoot\backup.ps1 -Verify" -ForegroundColor Yellow
            break
        }

        $prevTotal = $curTotal
        $prevTime  = $now
        Start-Sleep -Seconds $IntervalSec
    }
}
finally {
    Write-Progress -Activity "Sauvegarde" -Completed
}
