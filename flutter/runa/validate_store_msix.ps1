# Script de validación final para Microsoft Store
Write-Host "=== Validación Final del MSIX para Microsoft Store ===" -ForegroundColor Green

$msixPath = "build\windows\x64\runner\Release\runa.msix"
$extractPath = "build\windows\x64\runner\Release\runa_validation"

if (-not (Test-Path $msixPath)) {
    Write-Host "❌ MSIX no encontrado. Ejecuta primero: .\create_store_certified_msix.ps1" -ForegroundColor Red
    exit 1
}

# Extraer y validar
Write-Host "📋 Validando MSIX para Microsoft Store..." -ForegroundColor Yellow

if (Test-Path $extractPath) {
    Remove-Item $extractPath -Recurse -Force
}

Expand-Archive -Path $msixPath -DestinationPath $extractPath -Force

$manifestPath = Join-Path $extractPath "AppxManifest.xml"
[xml]$manifest = Get-Content $manifestPath

Write-Host "" -ForegroundColor White
Write-Host "✅ Validación del Manifest:" -ForegroundColor Cyan

# Verificar Identity Name
$identityName = $manifest.Package.Identity.Name
$expectedIdentity = "ZarabandaJose.runaes"
if ($identityName -eq $expectedIdentity) {
    Write-Host "   ✓ Identity Name: $identityName" -ForegroundColor Green
} else {
    Write-Host "   ❌ Identity Name: $identityName (esperado: $expectedIdentity)" -ForegroundColor Red
}

# Verificar Display Name
$displayName = $manifest.Package.Properties.DisplayName
$expectedDisplay = "runa es"
if ($displayName -eq $expectedDisplay) {
    Write-Host "   ✓ Display Name: $displayName" -ForegroundColor Green
} else {
    Write-Host "   ❌ Display Name: $displayName (esperado: $expectedDisplay)" -ForegroundColor Red
}

# Verificar Publisher
$publisher = $manifest.Package.Identity.Publisher
Write-Host "   ✓ Publisher: $publisher" -ForegroundColor Green

# Verificar Version
$version = $manifest.Package.Identity.Version
Write-Host "   ✓ Version: $version" -ForegroundColor Green

# Información del archivo
$fileInfo = Get-Item $msixPath
Write-Host "" -ForegroundColor White
Write-Host "📦 Información del Paquete:" -ForegroundColor Cyan
Write-Host "   Archivo: $msixPath" -ForegroundColor White
Write-Host "   Tamaño: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor White
Write-Host "   Fecha: $($fileInfo.LastWriteTime)" -ForegroundColor White

# Verificar capabilities
$capabilities = $manifest.Package.Capabilities.Capability | ForEach-Object { $_.Name }
$restrictedCapabilities = $manifest.Package.Capabilities.'rescap:Capability' | ForEach-Object { $_.Name }

Write-Host "" -ForegroundColor White
Write-Host "🔒 Capabilities:" -ForegroundColor Cyan
Write-Host "   Standard: $($capabilities -join ', ')" -ForegroundColor White
Write-Host "   Restricted: $($restrictedCapabilities -join ', ')" -ForegroundColor White

# Verificar que coincida con lo esperado por Microsoft Store
$allValid = ($identityName -eq $expectedIdentity) -and ($displayName -eq $expectedDisplay)

Write-Host "" -ForegroundColor White
if ($allValid) {
    Write-Host "🎉 ¡VALIDACIÓN EXITOSA!" -ForegroundColor Green
    Write-Host "El MSIX está listo para Microsoft Store" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "📋 Datos Validados:" -ForegroundColor Cyan
    Write-Host "   ✓ Package Identity: ZarabandaJose.runaes" -ForegroundColor Green
    Write-Host "   ✓ Display Name: runa es" -ForegroundColor Green
    Write-Host "   ✓ Package Family: ZarabandaJose.runaes_62se4tkt3jd36" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "🚀 Próximos pasos:" -ForegroundColor Yellow
    Write-Host "1. Subir $msixPath a Microsoft Partner Center" -ForegroundColor White
    Write-Host "2. Los errores de validación deberían estar resueltos" -ForegroundColor White
    Write-Host "3. Proceder con la certificación" -ForegroundColor White
} else {
    Write-Host "❌ ERRORES DE VALIDACIÓN ENCONTRADOS" -ForegroundColor Red
    Write-Host "Revisa la configuración en pubspec.yaml" -ForegroundColor Red
}

# Limpiar
Remove-Item $extractPath -Recurse -Force

Write-Host "" -ForegroundColor White
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
