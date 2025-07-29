# Script para preparar y subir documentos de privacidad a GitHub
Write-Host "=== Preparando documentos para GitHub ===" -ForegroundColor Green

# Verificar que estemos en el directorio correcto
if (-not (Test-Path "PRIVACY_POLICY.md")) {
    Write-Host "❌ No estás en el directorio raíz del proyecto Runa" -ForegroundColor Red
    Write-Host "Navega a c:\Code\Multi\Runa\" -ForegroundColor Yellow
    exit 1
}

Write-Host "📋 Documentos encontrados:" -ForegroundColor Cyan

# Verificar archivos creados
$documents = @(
    "PRIVACY_POLICY.md",
    "TERMS_OF_SERVICE.md", 
    "privacy-policy.html",
    "README.md"
)

foreach ($doc in $documents) {
    if (Test-Path $doc) {
        $fileInfo = Get-Item $doc
        $fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 1)
        Write-Host "   ✅ $doc ($fileSizeKB KB)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $doc (no encontrado)" -ForegroundColor Red
    }
}

Write-Host "" -ForegroundColor White
Write-Host "🌐 URLs que tendrás disponibles después de subir a GitHub:" -ForegroundColor Yellow

$githubUser = "jozzer182"
$repoName = "Runa"
$baseUrl = "https://raw.githubusercontent.com/$githubUser/$repoName/main"
$pagesUrl = "https://$githubUser.github.io/$repoName"

Write-Host "" -ForegroundColor White
Write-Host "📜 Política de Privacidad (Markdown):" -ForegroundColor Cyan
Write-Host "   $baseUrl/PRIVACY_POLICY.md" -ForegroundColor White

Write-Host "" -ForegroundColor White  
Write-Host "📋 Términos de Servicio:" -ForegroundColor Cyan
Write-Host "   $baseUrl/TERMS_OF_SERVICE.md" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "🌐 Política de Privacidad (Web - Para Stores):" -ForegroundColor Cyan
Write-Host "   $pagesUrl/privacy-policy.html" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "📖 README actualizado:" -ForegroundColor Cyan
Write-Host "   https://github.com/$githubUser/$repoName" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "🚀 Comandos Git para subir los cambios:" -ForegroundColor Yellow
Write-Host "" -ForegroundColor White

Write-Host "# 1. Agregar archivos nuevos" -ForegroundColor Green
Write-Host "git add PRIVACY_POLICY.md TERMS_OF_SERVICE.md privacy-policy.html README.md" -ForegroundColor Gray

Write-Host "" -ForegroundColor White
Write-Host "# 2. Commit con mensaje descriptivo" -ForegroundColor Green
Write-Host 'git commit -m "Add privacy policy and terms of service for app stores"' -ForegroundColor Gray

Write-Host "" -ForegroundColor White
Write-Host "# 3. Subir al repositorio" -ForegroundColor Green
Write-Host "git push origin main" -ForegroundColor Gray

Write-Host "" -ForegroundColor White
Write-Host "📱 Para Huawei AppGallery, usa esta URL:" -ForegroundColor Yellow
Write-Host "   $pagesUrl/privacy-policy.html" -ForegroundColor Cyan

Write-Host "" -ForegroundColor White
Write-Host "🔧 Configuración adicional necesaria:" -ForegroundColor Yellow
Write-Host "1. Habilitar GitHub Pages:" -ForegroundColor White
Write-Host "   - Ve a Settings > Pages en tu repositorio" -ForegroundColor Gray
Write-Host "   - Source: Deploy from a branch" -ForegroundColor Gray
Write-Host "   - Branch: main / (root)" -ForegroundColor Gray

Write-Host "" -ForegroundColor White
Write-Host "2. Esperar 5-10 minutos para que GitHub Pages se active" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "3. Actualizar tu correo en los documentos:" -ForegroundColor White
Write-Host "   - Busca '[Tu correo electrónico]' en los archivos" -ForegroundColor Gray
Write-Host "   - Reemplaza con tu correo real" -ForegroundColor Gray

Write-Host "" -ForegroundColor White
Write-Host "✨ Características de los documentos creados:" -ForegroundColor Green
Write-Host "   ✅ Cumplen con GDPR, CCPA, LGPD" -ForegroundColor White
Write-Host "   ✅ Específicos para apps que usan Firebase" -ForegroundColor White
Write-Host "   ✅ Enfoque en privacidad por diseño" -ForegroundColor White
Write-Host "   ✅ Formato profesional para app stores" -ForegroundColor White
Write-Host "   ✅ Versión web responsive y atractiva" -ForegroundColor White

Write-Host "" -ForegroundColor White
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
