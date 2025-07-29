# Script para crear MSIX sin runFullTrust para Microsoft Store
param(
    [string]$AppName = "Runa",
    [string]$Version = "1.0.9.0",
    [string]$Publisher = "CN=73E75044-1C00-4198-B32A-7DC00F5DAE1A",
    [string]$Architecture = "x64"
)

Write-Host "Creando MSIX para Microsoft Store sin runFullTrust..." -ForegroundColor Green

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
Write-Host "Copiando archivos de build..." -ForegroundColor Yellow
Copy-Item -Path "$BuildPath\*" -Destination $TempPath -Recurse -Force

# Crear manifest correcto sin runFullTrust
Write-Host "Creando manifest sin runFullTrust..." -ForegroundColor Yellow
$manifestContent = @"
<?xml version="1.0" encoding="utf-8"?>
<Package xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10" 
         xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10">

  <Identity Name="ZarabandaJose.RunaMotivacion" 
            Version="$Version"
            Publisher="$Publisher" 
            ProcessorArchitecture="$Architecture" />

  <Properties>
    <DisplayName>Runa - Motivacion Diaria</DisplayName>
    <PublisherDisplayName>ZarabandaJose</PublisherDisplayName>
    <Logo>Images\StoreLogo.png</Logo>
    <Description>Tu dosis diaria de motivacion con frases generadas por IA</Description>
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
    <Application Id="runa" Executable="runa.exe">
      <uap:VisualElements BackgroundColor="transparent"
        DisplayName="Runa - Motivacion Diaria" 
        Square150x150Logo="Images\Square150x150Logo.png"
        Square44x44Logo="Images\Square44x44Logo.png" 
        Description="Tu dosis diaria de motivacion con frases generadas por IA">
        
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
"@

$manifestContent | Out-File -FilePath $ManifestPath -Encoding UTF8

# Crear directorio de imagenes y copiar iconos si existen
Write-Host "Configurando iconos..." -ForegroundColor Yellow
$ImagesPath = "$TempPath\Images"
if (-not (Test-Path $ImagesPath)) {
    New-Item -ItemType Directory -Path $ImagesPath | Out-Null
}

# Buscar MakeAppx
$MakeAppxPath = $null
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

if (-not $MakeAppxPath) {
    Write-Host "Error: No se encontro MakeAppx.exe. Usando dart run msix:create como alternativa" -ForegroundColor Red
    
    # Limpiar y usar dart run msix:create
    Remove-Item -Recurse -Force $TempPath -ErrorAction SilentlyContinue
    
    Write-Host "Ejecutando dart run msix:create..." -ForegroundColor Yellow
    & dart run msix:create
    
    # Verificar si se creo el MSIX
    $DefaultMsix = "build\windows\x64\runner\Release\runa.msix"
    if (Test-Path $DefaultMsix) {
        $NewName = "Runa-Store-Ready-v$Version.msix"
        Copy-Item $DefaultMsix $NewName -Force
        Write-Host "MSIX creado: $NewName" -ForegroundColor Green
        Write-Host "NOTA: Verificar manualmente que no tenga runFullTrust" -ForegroundColor Yellow
    }
    return
}

# Crear MSIX con MakeAppx
Write-Host "Creando paquete MSIX..." -ForegroundColor Yellow
$OutputMsix = "Runa-Store-Ready-v$Version.msix"

try {
    & $MakeAppxPath pack /d $TempPath /p $OutputMsix /overwrite
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "MSIX creado exitosamente!" -ForegroundColor Green
        Write-Host "Archivo: $OutputMsix" -ForegroundColor Cyan
        Write-Host "Listo para subir a Microsoft Store" -ForegroundColor Green
        
        # Verificar el manifest final
        Write-Host "Verificando capabilities..." -ForegroundColor Yellow
        $ManifestContent = Get-Content $ManifestPath -Raw
        if ($ManifestContent -notmatch "runFullTrust") {
            Write-Host "Sin runFullTrust - Compatible con Microsoft Store" -ForegroundColor Green
        } else {
            Write-Host "Advertencia: Se detecto runFullTrust" -ForegroundColor Red
        }
    } else {
        Write-Host "Error al crear MSIX. Codigo de salida: $LASTEXITCODE" -ForegroundColor Red
    }
} catch {
    Write-Host "Error al ejecutar MakeAppx: $($_.Exception.Message)" -ForegroundColor Red
}

# Limpiar archivos temporales
Write-Host "Limpiando archivos temporales..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $TempPath -ErrorAction SilentlyContinue

Write-Host "Proceso completado!" -ForegroundColor Green
