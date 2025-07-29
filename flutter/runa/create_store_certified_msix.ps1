# Script para crear MSIX certificado para Microsoft Store
# Este script acepta runFullTrust pero optimiza para certificación

param(
    [string]$ProjectPath = ".",
    [string]$OutputPath = "build\windows\x64\runner\Release"
)

Write-Host "=== Creando MSIX para Microsoft Store ===" -ForegroundColor Green

# Limpiar y preparar
Write-Host "Limpiando proyecto..." -ForegroundColor Yellow
flutter clean
flutter pub get

# Construir con optimizaciones
Write-Host "Construyendo aplicación optimizada..." -ForegroundColor Yellow
flutter build windows --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# Crear MSIX con configuración optimizada
Write-Host "Creando MSIX optimizado..." -ForegroundColor Yellow
dart run msix:create

# Verificar que el MSIX se haya creado
$msixPath = Join-Path $OutputPath "runa.msix"
if (Test-Path $msixPath) {
    Write-Host "✅ MSIX creado exitosamente: $msixPath" -ForegroundColor Green
    
    # Información del archivo
    $fileInfo = Get-Item $msixPath
    Write-Host "   Tamaño: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "   Fecha: $($fileInfo.LastWriteTime)" -ForegroundColor Cyan
    
    # Extraer y verificar manifest
    $extractPath = Join-Path $OutputPath "runa_verification"
    if (Test-Path $extractPath) {
        Remove-Item $extractPath -Recurse -Force
    }
    
    Write-Host "Verificando manifest..." -ForegroundColor Yellow
    Expand-Archive -Path $msixPath -DestinationPath $extractPath -Force
    
    $manifestPath = Join-Path $extractPath "AppxManifest.xml"
    if (Test-Path $manifestPath) {
        [xml]$manifest = Get-Content $manifestPath
        
        Write-Host "📋 Información del manifest:" -ForegroundColor Cyan
        Write-Host "   Nombre: $($manifest.Package.Identity.Name)" -ForegroundColor White
        Write-Host "   Versión: $($manifest.Package.Identity.Version)" -ForegroundColor White
        Write-Host "   Publisher: $($manifest.Package.Identity.Publisher)" -ForegroundColor White
        
        # Verificar capabilities
        $capabilities = $manifest.Package.Capabilities.Capability | ForEach-Object { $_.Name }
        $restrictedCapabilities = $manifest.Package.Capabilities.'rescap:Capability' | ForEach-Object { $_.Name }
        
        Write-Host "   Capabilities: $($capabilities -join ', ')" -ForegroundColor White
        Write-Host "   Restricted Capabilities: $($restrictedCapabilities -join ', ')" -ForegroundColor White
        
        # Verificar EntryPoint
        $entryPoint = $manifest.Package.Applications.Application.EntryPoint
        Write-Host "   Entry Point: $entryPoint" -ForegroundColor White
        
        if ($restrictedCapabilities -contains "runFullTrust") {
            Write-Host "⚠️  NOTA: La aplicación requiere runFullTrust (normal para Flutter Windows)" -ForegroundColor Yellow
            Write-Host "   Esto es aceptable para Microsoft Store con certificación adicional." -ForegroundColor Yellow
        }
    }
    
    # Limpiar extracción
    Remove-Item $extractPath -Recurse -Force
    
    Write-Host "🎉 MSIX listo para subir a Microsoft Store!" -ForegroundColor Green
    Write-Host "📁 Ubicación: $msixPath" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "1. Subir el MSIX al Partner Center de Microsoft" -ForegroundColor White
    Write-Host "2. Completar la información de la aplicación" -ForegroundColor White
    Write-Host "3. Enviar para certificación" -ForegroundColor White
    Write-Host "4. La aplicación será revisada por el equipo de Microsoft" -ForegroundColor White
    
} else {
    Write-Host "❌ Error: No se pudo crear el MSIX" -ForegroundColor Red
    exit 1
}
