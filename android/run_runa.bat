@echo off
echo 🚀 Iniciando Runa - Tu dosis diaria de motivacion...
echo.

echo 📱 Verificando dispositivos Android conectados...
adb devices
echo.

echo 🔧 Construyendo la aplicacion...
call gradlew assembleDebug
if %ERRORLEVEL% neq 0 (
    echo ❌ Error al construir la aplicacion
    pause
    exit /b 1
)
echo.

echo 📲 Instalando en dispositivo/emulador...
call gradlew installDebug
if %ERRORLEVEL% neq 0 (
    echo ❌ Error al instalar la aplicacion
    pause
    exit /b 1
)
echo.

echo ✅ Runa instalada correctamente!
echo 🎉 Busca la app "Runa" en tu dispositivo para abrirla
echo.
pause
