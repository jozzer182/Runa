# Script para crear certificado de prueba y MSIX firmado para instalación local
# Esto permite instalar la aplicación localmente antes de subirla a Microsoft Store

param(
    [string]$ProjectPath = ".",
    [string]$CertificateName = "RunaTestCertificate",
    [string]$Publisher = "CN=73E75044-1C00-4198-B32A-7DC00F5DAE1A"
)

Write-Host "=== Creando certificado de prueba para instalación local ===" -ForegroundColor Green

# Verificar si tenemos las herramientas necesarias
$makeCertPath = "makecert.exe"
$pvk2pfxPath = "pvk2pfx.exe"

# Buscar en Windows SDK
$sdkPaths = @(
    "${env:ProgramFiles(x86)}\Windows Kits\10\bin\*\x64",
    "${env:ProgramFiles}\Windows Kits\10\bin\*\x64",
    "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\*\bin\x64",
    "${env:ProgramFiles}\Microsoft SDKs\Windows\*\bin\x64"
)

$foundSdk = $false
foreach ($path in $sdkPaths) {
    $makeCertFound = Get-ChildItem -Path $path -Name "makecert.exe" -ErrorAction SilentlyContinue
    if ($makeCertFound) {
        $sdkBinPath = Split-Path (Get-ChildItem -Path $path -Name "makecert.exe" -Recurse | Select-Object -First 1).FullName
        $makeCertPath = Join-Path $sdkBinPath "makecert.exe"
        $pvk2pfxPath = Join-Path $sdkBinPath "pvk2pfx.exe"
        $foundSdk = $true
        Write-Host "✅ Windows SDK encontrado en: $sdkBinPath" -ForegroundColor Green
        break
    }
}

if (-not $foundSdk) {
    Write-Host "❌ Windows SDK no encontrado. Usando PowerShell para crear certificado..." -ForegroundColor Yellow
    
    # Método alternativo usando PowerShell
    $certPassword = ConvertTo-SecureString -String "test123" -Force -AsPlainText
    $cert = New-SelfSignedCertificate -Type Custom -Subject $Publisher -KeyUsage DigitalSignature -FriendlyName $CertificateName -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
    
    $certPath = ".\$CertificateName.pfx"
    Export-PfxCertificate -Cert $cert -FilePath $certPath -Password $certPassword
    
    Write-Host "✅ Certificado creado con PowerShell: $certPath" -ForegroundColor Green
    Write-Host "   Password: test123" -ForegroundColor Cyan
} else {
    # Método usando Windows SDK
    $certPath = ".\$CertificateName.pfx"
    $pvkPath = ".\$CertificateName.pvk"
    $cerPath = ".\$CertificateName.cer"
    
    Write-Host "Creando certificado con Windows SDK..." -ForegroundColor Yellow
    
    # Crear certificado
    & $makeCertPath -r -pe -n $Publisher -ss my -sr CurrentUser -a sha256 -cy end -sky signature -sv $pvkPath $cerPath
    
    # Convertir a PFX
    & $pvk2pfxPath -pvk $pvkPath -spc $cerPath -pfx $certPath -po "test123"
    
    Write-Host "✅ Certificado creado: $certPath" -ForegroundColor Green
    Write-Host "   Password: test123" -ForegroundColor Cyan
}

# Actualizar pubspec.yaml con el certificado
Write-Host "Actualizando configuración MSIX..." -ForegroundColor Yellow

$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw

# Actualizar la configuración del certificado
$newConfig = $pubspecContent -replace "certificate_path: null", "certificate_path: $CertificateName.pfx"
$newConfig = $newConfig -replace "certificate_password: null", "certificate_password: test123"
$newConfig = $newConfig -replace "msix_version: 1\.0\.11\.0", "msix_version: 1.0.12.0"

Set-Content -Path $pubspecPath -Value $newConfig

Write-Host "✅ Configuración actualizada" -ForegroundColor Green

# Crear MSIX firmado
Write-Host "Creando MSIX firmado..." -ForegroundColor Yellow

flutter clean
flutter pub get
dart run msix:create

$msixPath = "build\windows\x64\runner\Release\runa.msix"
if (Test-Path $msixPath) {
    Write-Host "✅ MSIX firmado creado exitosamente!" -ForegroundColor Green
    Write-Host "📁 Ubicación: $msixPath" -ForegroundColor Cyan
    
    # Información del archivo
    $fileInfo = Get-Item $msixPath
    Write-Host "   Tamaño: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor White
    
    Write-Host "" -ForegroundColor White
    Write-Host "📋 Instrucciones para instalación local:" -ForegroundColor Cyan
    Write-Host "1. Instalar el certificado:" -ForegroundColor White
    Write-Host "   - Doble clic en $CertificateName.cer" -ForegroundColor Yellow
    Write-Host "   - Instalar certificado -> Máquina local" -ForegroundColor Yellow
    Write-Host "   - Colocar en 'Entidades de certificación raíz de confianza'" -ForegroundColor Yellow
    Write-Host "2. Después instalar la aplicación:" -ForegroundColor White
    Write-Host "   - Doble clic en $msixPath" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor White
    Write-Host "⚠️  IMPORTANTE: Para Microsoft Store, usar el MSIX SIN certificado" -ForegroundColor Red
    Write-Host "   (Microsoft Store firma automáticamente con su certificado)" -ForegroundColor Red
} else {
    Write-Host "❌ Error al crear MSIX" -ForegroundColor Red
}
