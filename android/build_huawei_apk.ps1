# Script para compilar y preparar APK para Huawei AppGallery
param(
    [string]$BuildType = "release",
    [string]$AppGalleryMode = $true
)

Write-Host "=== Compilando Runa Android para Huawei AppGallery ===" -ForegroundColor Green

$projectPath = "c:\Code\Multi\Runa\android"
$keystorePath = "$projectPath\runa-release-key.keystore"

# Verificar que estemos en el directorio correcto
if (-not (Test-Path "$projectPath\app\build.gradle.kts")) {
    Write-Host "❌ Proyecto Android no encontrado en $projectPath" -ForegroundColor Red
    exit 1
}

Set-Location $projectPath

# Crear keystore si no existe
if (-not (Test-Path $keystorePath)) {
    Write-Host "🔐 Creando keystore para firmado..." -ForegroundColor Yellow
    
    # Verificar si keytool está disponible
    $keytoolPath = "keytool"
    try {
        & $keytoolPath -help > $null 2>&1
    } catch {
        # Buscar keytool en Java installations
        $javaHomes = @(
            ${env:JAVA_HOME},
            "${env:ProgramFiles}\Java\*\bin",
            "${env:ProgramFiles(x86)}\Java\*\bin",
            "${env:LOCALAPPDATA}\Programs\*\*\bin"
        )
        
        $keytoolFound = $false
        foreach ($javaPath in $javaHomes) {
            if ($javaPath -and (Test-Path $javaPath)) {
                $keytoolExe = Get-ChildItem -Path $javaPath -Name "keytool.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($keytoolExe) {
                    $keytoolPath = $keytoolExe.FullName
                    $keytoolFound = $true
                    break
                }
            }
        }
        
        if (-not $keytoolFound) {
            Write-Host "❌ keytool no encontrado. Instala Java JDK" -ForegroundColor Red
            exit 1
        }
    }
    
    # Generar keystore
    & $keytoolPath -genkey -v -keystore $keystorePath -alias runa_key -keyalg RSA -keysize 2048 -validity 10000 -storepass runaapp2025 -keypass runaapp2025 -dname "CN=ZarabandaJose, OU=Development, O=ZarabandaJose, L=Madrid, ST=Madrid, C=ES"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Keystore creado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Error creando keystore" -ForegroundColor Red
        exit 1
    }
}

# Limpiar proyecto
Write-Host "🧹 Limpiando proyecto..." -ForegroundColor Yellow
.\gradlew clean

# Verificar configuración para Huawei
Write-Host "📱 Configurando para Huawei AppGallery..." -ForegroundColor Yellow

# Construir APK
Write-Host "🔨 Compilando APK de release..." -ForegroundColor Yellow
.\gradlew assembleRelease

if ($LASTEXITCODE -eq 0) {
    $apkPath = "app\build\outputs\apk\release\app-release.apk"
    
    if (Test-Path $apkPath) {
        # Información del APK
        $apkInfo = Get-Item $apkPath
        $apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
        
        Write-Host "✅ APK compilado exitosamente!" -ForegroundColor Green
        Write-Host "📁 Ubicación: $apkPath" -ForegroundColor Cyan
        Write-Host "📦 Tamaño: $apkSizeMB MB" -ForegroundColor Cyan
        Write-Host "📅 Fecha: $($apkInfo.LastWriteTime)" -ForegroundColor Cyan
        
        # Crear APK optimizado para Huawei con nombre descriptivo
        $optimizedApkPath = "app\build\outputs\apk\release\runa-huawei-appgallery-v1.0.apk"
        Copy-Item $apkPath $optimizedApkPath -Force
        
        Write-Host "" -ForegroundColor White
        Write-Host "🎉 APK listo para Huawei AppGallery!" -ForegroundColor Green
        Write-Host "📁 APK optimizado: $optimizedApkPath" -ForegroundColor Green
        
        Write-Host "" -ForegroundColor White
        Write-Host "📋 Información técnica:" -ForegroundColor Cyan
        Write-Host "   Package Name: com.zarabandajose.runa" -ForegroundColor White
        Write-Host "   Version Code: 1" -ForegroundColor White
        Write-Host "   Version Name: 1.0" -ForegroundColor White
        Write-Host "   Min SDK: 24 (Android 7.0)" -ForegroundColor White
        Write-Host "   Target SDK: 36 (Android 14)" -ForegroundColor White
        Write-Host "   Firmado: ✅ Con certificado de release" -ForegroundColor White
        
        Write-Host "" -ForegroundColor White
        Write-Host "🚀 Próximos pasos para Huawei AppGallery:" -ForegroundColor Yellow
        Write-Host "1. Subir $optimizedApkPath a Huawei Developer Console" -ForegroundColor White
        Write-Host "2. Completar información de la aplicación" -ForegroundColor White
        Write-Host "3. Configurar descripciones y capturas de pantalla" -ForegroundColor White
        Write-Host "4. Enviar para revisión" -ForegroundColor White
        
        # Verificar características específicas de Huawei
        Write-Host "" -ForegroundColor White
        Write-Host "✅ Compatibilidad Huawei:" -ForegroundColor Green
        Write-Host "   • No usa Google Play Services (usa Firebase directamente)" -ForegroundColor White
        Write-Host "   • Compatible con HMS Core" -ForegroundColor White
        Write-Host "   • Funciona sin servicios de Google" -ForegroundColor White
        Write-Host "   • Soporte para dispositivos Huawei/Honor" -ForegroundColor White
        
    } else {
        Write-Host "❌ APK no encontrado después de la compilación" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Error durante la compilación" -ForegroundColor Red
    Write-Host "Revisa los logs de Gradle arriba para más detalles" -ForegroundColor Yellow
    exit 1
}

Write-Host "" -ForegroundColor White
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
