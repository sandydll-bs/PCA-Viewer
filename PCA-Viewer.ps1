$dir = "C:\Windows\appcompat\pca\PcaAppLaunchDic.txt"

function ControllaStato {
    param ([string]$fileInput)
    if (-not (Test-Path -Path $fileInput -PathType Leaf)) {
        return "Not Found"
    }
    try {
        $sig = Get-AuthenticodeSignature -FilePath $fileInput -ErrorAction Stop
        if ($sig.Status -eq "Valid") {
            return "Signed"
        } else {
            return "Unsigned"
        }
    } catch {
        return "Unsigned"
    }
}

function ElaboraPca {
    if (Test-Path $dir) {
        $contenutoGrezzo = [System.IO.File]::ReadAllText($dir, [System.Text.Encoding]::Default)
        $pattern = '(C:\\[^|]+\|\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})'
        $matches = [regex]::Matches($contenutoGrezzo, $pattern)
        $i = 0
        foreach ($match in $matches) {
            $i++
            Write-Progress -Activity "Analisi file PCA in corso..." -Status "Elaborazione riga $i di $($matches.Count)" -PercentComplete (($i / $matches.Count) * 100)
            $parti = $match.Value.Split('|')
            $percorsoCorrente = $parti[0].Trim()
            $statoFile = ControllaStato -fileInput $percorsoCorrente
            [PSCustomObject]@{
                Percorso  = $percorsoCorrente
                Timestamp = $parti[1].Trim()
                Signature = $statoFile
            }
        }
    } else {
        Write-Host "File non trovato. Esegui come Amministratore." -ForegroundColor Red
    }
}

$risultati = @(ElaboraPca)

if ($risultati.Count -gt 0) {
    $risultati | Out-GridView -Title "PCA Viewer - DS: @imsandy.dll"
} else {
    Write-Host "Nessun dato estratto. Verifica l'integrità del file." -ForegroundColor Yellow
}