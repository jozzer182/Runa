# Script para crear MSIX sin runFullTrust para Microsoft Store
# PowerShell script para empaquetado correcto de Runa

param(
    [string]$AppName = "Runa",
    [string]$Version = "1.0.9.0",
    [string]$Publisher = "CN=73E75044-1C00-4198-B32A-7DC00F5DAE1A",
    [string]$Architecture = "x64"
)

Write-Host "🚀 Creando MSIX para Microsoft Store sin runFullTrust..." -ForegroundColor Green

# Rutas
$BuildPath = "build\windows\x64\runner\Release"
$TempPath = "temp_msix_build"
$ManifestPath = "$TempPath\AppxManifest.xml"

# Crear directorio temporal
if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force $TempPath
}
New-Item -ItemType Directory -Path $TempPath | Out-Null

# Copiar archivos de la build
Write-Host "📁 Copiando archivos de build..." -ForegroundColor Yellow
Copy-Item -Path "$BuildPath\*" -Destination $TempPath -Recurse -Force

# Crear manifest correcto sin runFullTrust
Write-Host "📝 Creando manifest sin runFullTrust..." -ForegroundColor Yellow
@"
<?xml version="1.0" encoding="utf-8"?>
<Package xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10" 
         xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10" 
         xmlns:rescap="http://schemas.microsoft.com/appx/manifest/foundation/windows10/restrictedcapabilities">

  <Identity Name="ZarabandaJose.RunaMotivacion" 
            Version="$Version"
            Publisher="$Publisher" 
            ProcessorArchitecture="$Architecture" />

  <Properties>
    <DisplayName>Runa - Motivación Diaria</DisplayName>
    <PublisherDisplayName>ZarabandaJose</PublisherDisplayName>
    <Logo>Images\StoreLogo.png</Logo>
    <Description>Tu dosis diaria de motivación con frases generadas por IA. Encuentra inspiración y mantente motivado todos los días.</Description>
  </Properties>

  <Resources>
    <Resource Language="es-ES" />
  </Resources>

  <Dependencies>
    <TargetDeviceFamily Name="Windows.Desktop" MinVersion="10.0.17763.0" MaxVersionTested="10.0.22621.2506" />
  </Dependencies>

  <Capabilities>
    <Capability Name="internetClient" />
  </Capabilities>

  <Applications>
    <Application Id="runa" Executable="runa.exe" EntryPoint="Windows.FullTrustApplication">
      <uap:VisualElements BackgroundColor="transparent"
        DisplayName="Runa - Motivación Diaria" 
        Square150x150Logo="Images\Square150x150Logo.png"
        Square44x44Logo="Images\Square44x44Logo.png" 
        Description="Tu dosis diaria de motivación con frases generadas por IA">
        
        <uap:DefaultTile ShortName="Runa" 
          Square310x310Logo="Images\LargeTile.png"
          Square71x71Logo="Images\SmallTile.png" 
          Wide310x150Logo="Images\Wide310x150Logo.png">
          <uap:ShowNameOnTiles>
            <uap:ShowOn Tile="square150x150Logo"/>
            <uap:ShowOn Tile="square310x310Logo"/>
            <uap:ShowOn Tile="wide310x150Logo"/>
          </uap:ShowNameOnTiles>
        </uap:DefaultTile>
        
        <uap:SplashScreen Image="Images\SplashScreen.png"/>
      </uap:VisualElements>
    </Application>
  </Applications>

</Package>
"@ | Out-File -FilePath $ManifestPath -Encoding UTF8

# Crear directorio de imágenes y copiar iconos si existen
Write-Host "🖼️ Configurando iconos..." -ForegroundColor Yellow
$ImagesPath = "$TempPath\Images"
if (-not (Test-Path $ImagesPath)) {
    New-Item -ItemType Directory -Path $ImagesPath | Out-Null
}

# Verificar si existe MakeAppx
$MakeAppxPath = Get-Command "MakeAppx.exe" -ErrorAction SilentlyContinue
if (-not $MakeAppxPath) {
    # Buscar en ubicaciones comunes
    $CommonPaths = @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\*\x64\MakeAppx.exe",
        "${env:ProgramFiles}\Windows Kits\10\bin\*\x64\MakeAppx.exe"
    )
    
    foreach ($Path in $CommonPaths) {
        $Found = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
        if ($Found) {
            $MakeAppxPath = $Found.FullName
            break
        }
    }
}

if (-not $MakeAppxPath) {
    Write-Host "❌ Error: No se encontró MakeAppx.exe. Instala Windows SDK." -ForegroundColor Red
    Write-Host "💡 Tip: Puedes usar 'dart run msix:create' como alternativa" -ForegroundColor Cyan
    exit 1
}

# Crear MSIX
Write-Host "📦 Creando paquete MSIX..." -ForegroundColor Yellow
$OutputMsix = "Runa-Store-Ready-v$Version.msix"

try {
    & $MakeAppxPath pack /d $TempPath /p $OutputMsix /overwrite
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ ¡MSIX creado exitosamente!" -ForegroundColor Green
        Write-Host "📁 Archivo: $OutputMsix" -ForegroundColor Cyan
        Write-Host "🏪 Listo para subir a Microsoft Store" -ForegroundColor Green
        
        # Verificar el manifest final
        Write-Host "`n🔍 Verificando capabilities..." -ForegroundColor Yellow
        $ManifestContent = Get-Content $ManifestPath -Raw
        if ($ManifestContent -notmatch "runFullTrust") {
            Write-Host "✅ Sin runFullTrust - Compatible con Microsoft Store" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Advertencia: Se detectó runFullTrust" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Error al crear MSIX. Código de salida: $LASTEXITCODE" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error al ejecutar MakeAppx: $($_.Exception.Message)" -ForegroundColor Red
}

# Limpiar archivos temporales
Write-Host "`n🧹 Limpiando archivos temporales..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $TempPath -ErrorAction SilentlyContinue

Write-Host "`n🎉 Proceso completado!" -ForegroundColor Green
