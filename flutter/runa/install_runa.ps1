# Script para instalar automáticamente el certificado y la aplicación
Write-Host "=== Instalador Automático de Runa ===" -ForegroundColor Green

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Reiniciando como administrador..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File", $PSCommandPath
    exit
}

try {
    # Instalar certificado
    $cerPath = ".\RunaTestCertificate.cer"
    if (Test-Path $cerPath) {
        Write-Host "📜 Instalando certificado de confianza..." -ForegroundColor Yellow
        Import-Certificate -FilePath $cerPath -CertStoreLocation Cert:\LocalMachine\Root
        Write-Host "✅ Certificado instalado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Certificado no encontrado: $cerPath" -ForegroundColor Red
        Write-Host "Ejecuta primero: .\create_signed_msix.ps1" -ForegroundColor Yellow
        exit 1
    }
    
    # Instalar aplicación
    $msixPath = "build\windows\x64\runner\Release\runa.msix"
    if (Test-Path $msixPath) {
        Write-Host "📱 Instalando aplicación Runa..." -ForegroundColor Yellow
        Add-AppxPackage -Path $msixPath
        Write-Host "✅ Aplicación instalada exitosamente!" -ForegroundColor Green
        Write-Host "" -ForegroundColor White
        Write-Host "🎉 ¡Runa está lista para usar!" -ForegroundColor Cyan
        Write-Host "Puedes encontrar la aplicación en el menú inicio" -ForegroundColor White
    } else {
        Write-Host "❌ MSIX no encontrado: $msixPath" -ForegroundColor Red
        Write-Host "Ejecuta primero: .\create_signed_msix.ps1" -ForegroundColor Yellow
        exit 1
    }
    
} catch {
    Write-Host "❌ Error durante la instalación: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "" -ForegroundColor White
    Write-Host "💡 Instalación manual:" -ForegroundColor Cyan
    Write-Host "1. Clic derecho en RunaTestCertificate.cer -> Instalar certificado" -ForegroundColor Yellow
    Write-Host "2. Máquina local -> Entidades de certificación raíz de confianza" -ForegroundColor Yellow
    Write-Host "3. Doble clic en build\windows\x64\runner\Release\runa.msix" -ForegroundColor Yellow
}

Write-Host "" -ForegroundColor White
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
