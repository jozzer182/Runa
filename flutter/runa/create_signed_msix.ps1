# Script simplificado para crear certificado de prueba usando PowerShell
param(
    [string]$CertificateName = "RunaTestCertificate",
    [string]$Publisher = "CN=73E75044-1C00-4198-B32A-7DC00F5DAE1A"
)

Write-Host "=== Creando certificado de prueba para instalación local ===" -ForegroundColor Green

try {
    # Crear certificado autofirmado
    Write-Host "Creando certificado autofirmado..." -ForegroundColor Yellow
    $certPassword = ConvertTo-SecureString -String "test123" -Force -AsPlainText
    
    # Crear certificado
    $cert = New-SelfSignedCertificate -Type Custom -Subject $Publisher -KeyUsage DigitalSignature -FriendlyName $CertificateName -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
    
    # Exportar certificado
    $certPath = ".\$CertificateName.pfx"
    $cerPath = ".\$CertificateName.cer"
    
    Export-PfxCertificate -Cert $cert -FilePath $certPath -Password $certPassword
    Export-Certificate -Cert $cert -FilePath $cerPath
    
    Write-Host "✅ Certificado creado exitosamente!" -ForegroundColor Green
    Write-Host "   PFX: $certPath (Password: test123)" -ForegroundColor Cyan
    Write-Host "   CER: $cerPath" -ForegroundColor Cyan
    
    # Verificar que el archivo existe
    if (Test-Path $certPath) {
        Write-Host "✅ Archivo PFX confirmado" -ForegroundColor Green
        
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
            Write-Host "1. INSTALAR EL CERTIFICADO PRIMERO:" -ForegroundColor Red
            Write-Host "   a) Clic derecho en $cerPath -> Instalar certificado" -ForegroundColor Yellow
            Write-Host "   b) Elegir 'Máquina local' -> Siguiente" -ForegroundColor Yellow
            Write-Host "   c) Elegir 'Colocar todos los certificados en el siguiente almacén'" -ForegroundColor Yellow
            Write-Host "   d) Examinar -> Entidades de certificación raíz de confianza -> OK" -ForegroundColor Yellow
            Write-Host "   e) Siguiente -> Finalizar" -ForegroundColor Yellow
            Write-Host "" -ForegroundColor White
            Write-Host "2. DESPUÉS INSTALAR LA APLICACIÓN:" -ForegroundColor Green
            Write-Host "   - Doble clic en $msixPath" -ForegroundColor Yellow
            Write-Host "" -ForegroundColor White
            Write-Host "⚠️  IMPORTANTE: Para Microsoft Store, crear MSIX sin certificado:" -ForegroundColor Red
            Write-Host "   Ejecutar: .\create_store_certified_msix.ps1" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Error al crear MSIX firmado" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Error: No se pudo crear el archivo PFX" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error al crear certificado: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Intentando método alternativo..." -ForegroundColor Yellow
    
    # Método alternativo: crear MSIX sin firmar para prueba local
    Write-Host "Restaurando configuración sin certificado..." -ForegroundColor Yellow
    $pubspecPath = "pubspec.yaml"
    $pubspecContent = Get-Content $pubspecPath -Raw
    $newConfig = $pubspecContent -replace "certificate_path: RunaTestCertificate\.pfx", "certificate_path: null"
    $newConfig = $newConfig -replace "certificate_password: test123", "certificate_password: null"
    Set-Content -Path $pubspecPath -Value $newConfig
    
    Write-Host "⚠️  Para instalar localmente sin certificado:" -ForegroundColor Yellow
    Write-Host "1. Habilitar modo de desarrollador en Windows:" -ForegroundColor White
    Write-Host "   Configuración -> Actualización y seguridad -> Para desarrolladores" -ForegroundColor Yellow
    Write-Host "2. Instalar con PowerShell:" -ForegroundColor White
    Write-Host "   Add-AppxPackage -Path '.\build\windows\x64\runner\Release\runa.msix'" -ForegroundColor Yellow
}
