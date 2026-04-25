# Configuración inicial
$ytDlpPath = ".\yt-dlp.exe"
$vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"
$outputFile = "femebal_vivo.m3u8"

# Lista de clubes y sus URLs de vivo (agregué a San Lorenzo arriba por obvias razones)
$clubes = @(
    [PSCustomObject]@{ Nombre = "Femebal TV (Oficial)"; Url = "https://www.youtube.com/user/FemebalTV/live" },
    [PSCustomObject]@{ Nombre = "Handball de Primera"; Url = "https://www.youtube.com/@HandballdePrimera/live" },
    [PSCustomObject]@{ Nombre = "GoHandball"; Url = "https://www.youtube.com/@gohandball/live" },
    [PSCustomObject]@{ Nombre = "DEPORTV"; Url = "https://www.youtube.com/@canaldeportv/live" },
    [PSCustomObject]@{ Nombre = "San Lorenzo (CASLA)"; Url = "https://www.youtube.com/@HandballSanLorenzo/live" },
    [PSCustomObject]@{ Nombre = "Ferro Carril Oeste"; Url = "https://www.youtube.com/@fcohandballtv/live" },
    [PSCustomObject]@{ Nombre = "SAG Villa Ballester"; Url = "https://www.youtube.com/@BallesterHandball/live" },
    [PSCustomObject]@{ Nombre = "Dorrego Handball"; Url = "https://www.youtube.com/@DorregoRadioHandball/live" },
    [PSCustomObject]@{ Nombre = "N. Sra. de Luján"; Url = "https://www.youtube.com/@lujanhandball/live" },
    [PSCustomObject]@{ Nombre = "Boca Juniors"; Url = "https://www.youtube.com/@elcanaldeboca/live" },
    [PSCustomObject]@{ Nombre = "C.A. River Plate"; Url = "https://www.youtube.com/@cariverplatetv/live" },
    [PSCustomObject]@{ Nombre = "Mun. Vicente López (ViLo)"; Url = "https://www.youtube.com/@ViloHandball/live" },
    [PSCustomObject]@{ Nombre = "Mariano Acosta"; Url = "https://www.youtube.com/@MarianoAcostaHandball/live" }
)

$m3uContent = "#EXTM3U`n"

Write-Host "--- Iniciando extracción de enlaces de FeMeBal ---" -ForegroundColor Cyan

foreach ($club in $clubes) {
    Write-Host "Procesando: $($club.Nombre)..." -NoNewline
    
    # Ejecutamos yt-dlp para obtener el link directo al manifest .m3u8
    # Usamos -f 95 para asegurar calidad 720p o similar si está disponible
    $directUrl = & $ytDlpPath -g --format "best" $club.Url 2>$null
    
    if ($directUrl) {
        $m3uContent += "#EXTINF:-1, $($club.Nombre)`n$directUrl`n"
        Write-Host " [OK]" -ForegroundColor Green
    } else {
        Write-Host " [SIN VIVO / ERROR]" -ForegroundColor Yellow
    }
}

# Guardamos el archivo con encoding UTF8 sin BOM (el que le gusta a VLC)
$m3uContent | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "`nLista generada en: $outputFile" -ForegroundColor Cyan

# Abrimos VLC con la lista recién creada
if (Test-Path $vlcPath) {
    Write-Host "Abriendo VLC..."
    Start-Process $vlcPath -ArgumentList $outputFile
} else {
    Write-Host "VLC no encontrado en la ruta especificada." -ForegroundColor Red
}