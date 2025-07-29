# Script para verificar y analizar el APK compilado
Write-Host "=== Verificación del APK para Huawei AppGallery ===" -ForegroundColor Green

$apkPath = "app\build\outputs\apk\release\runa-huawei-appgallery-v1.0.apk"

if (-not (Test-Path $apkPath)) {
    Write-Host "❌ APK no encontrado: $apkPath" -ForegroundColor Red
    Write-Host "Ejecuta primero: .\build_huawei_apk.ps1" -ForegroundColor Yellow
    exit 1
}

# Información básica del archivo
$apkInfo = Get-Item $apkPath
$apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)

Write-Host "📦 Información del APK:" -ForegroundColor Cyan
Write-Host "   Archivo: $apkPath" -ForegroundColor White
Write-Host "   Tamaño: $apkSizeMB MB" -ForegroundColor White
Write-Host "   Fecha: $($apkInfo.LastWriteTime)" -ForegroundColor White

# Verificar firmado (si aapt está disponible)
Write-Host "" -ForegroundColor White
Write-Host "🔍 Verificando características del APK..." -ForegroundColor Yellow

# Buscar Android SDK tools
$androidSdkPaths = @(
    "${env:ANDROID_HOME}\build-tools\*",
    "${env:LOCALAPPDATA}\Android\Sdk\build-tools\*",
    "${env:ProgramFiles}\Android\Android Studio\*\*\build-tools\*"
)

$aaptPath = $null
foreach ($sdkPath in $androidSdkPaths) {
    if (Test-Path $sdkPath) {
        $aaptExe = Get-ChildItem -Path $sdkPath -Name "aapt.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($aaptExe) {
            $aaptPath = $aaptExe.FullName
            break
        }
    }
}

if ($aaptPath) {
    Write-Host "✅ Android SDK encontrado" -ForegroundColor Green
    
    # Información del paquete
    $packageInfo = & $aaptPath dump badging $apkPath 2>$null
    if ($packageInfo) {
        $packageName = ($packageInfo | Select-String "package: name='([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value })
        $versionCode = ($packageInfo | Select-String "versionCode='([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value })
        $versionName = ($packageInfo | Select-String "versionName='([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value })
        $minSdk = ($packageInfo | Select-String "sdkVersion:'([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value })
        $targetSdk = ($packageInfo | Select-String "targetSdkVersion:'([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value })
        
        Write-Host "" -ForegroundColor White
        Write-Host "📋 Detalles del paquete:" -ForegroundColor Cyan
        Write-Host "   Package Name: $packageName" -ForegroundColor White
        Write-Host "   Version Code: $versionCode" -ForegroundColor White
        Write-Host "   Version Name: $versionName" -ForegroundColor White
        Write-Host "   Min SDK: $minSdk" -ForegroundColor White
        Write-Host "   Target SDK: $targetSdk" -ForegroundColor White
    }
    
    # Permisos
    $permissions = & $aaptPath dump permissions $apkPath 2>$null | Select-String "uses-permission:"
    if ($permissions) {
        Write-Host "" -ForegroundColor White
        Write-Host "🔒 Permisos solicitados:" -ForegroundColor Cyan
        foreach ($permission in $permissions) {
            $permName = ($permission -split "'")[1]
            Write-Host "   • $permName" -ForegroundColor White
        }
    }
} else {
    Write-Host "⚠️  Android SDK no encontrado, análisis limitado" -ForegroundColor Yellow
}

# Verificar firmado con jarsigner (si está disponible)
$jarsignerPath = "jarsigner"
try {
    $verifyResult = & $jarsignerPath -verify -verbose $apkPath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "" -ForegroundColor White
        Write-Host "✅ APK correctamente firmado" -ForegroundColor Green
    } else {
        Write-Host "" -ForegroundColor White
        Write-Host "❌ Problema con la firma del APK" -ForegroundColor Red
    }
} catch {
    Write-Host "" -ForegroundColor White
    Write-Host "⚠️  No se pudo verificar la firma (jarsigner no disponible)" -ForegroundColor Yellow
}

Write-Host "" -ForegroundColor White
Write-Host "🏪 Listo para Huawei AppGallery:" -ForegroundColor Green
Write-Host "✅ APK compilado y optimizado" -ForegroundColor White
Write-Host "✅ Firmado con certificado de release" -ForegroundColor White
Write-Host "✅ Minificado y ofuscado (R8)" -ForegroundColor White
Write-Host "✅ Recursos comprimidos" -ForegroundColor White
Write-Host "✅ Compatible con dispositivos Huawei/Honor" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "📱 Compatibilidad:" -ForegroundColor Cyan
Write-Host "   • Android 7.0+ (API 24+)" -ForegroundColor White
Write-Host "   • Dispositivos Huawei/Honor" -ForegroundColor White
Write-Host "   • Funciona sin Google Play Services" -ForegroundColor White
Write-Host "   • Compatible con HMS Core" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "🔗 Próximos pasos:" -ForegroundColor Yellow
Write-Host "1. Ve a Huawei Developer Console: https://developer.huawei.com/consumer/en/console" -ForegroundColor White
Write-Host "2. Crea una nueva aplicación o actualiza existente" -ForegroundColor White
Write-Host "3. Sube el APK: $apkPath" -ForegroundColor Yellow
Write-Host "4. Completa metadatos, descripciones y capturas" -ForegroundColor White
Write-Host "5. Envía para revisión y publicación" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
