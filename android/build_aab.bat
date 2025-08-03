@echo off
echo === Generando Android App Bundle (AAB) para Play Store ===
echo.

cd /d "c:\Code\Multi\Runa\android"

echo Limpiando proyecto...
call gradlew clean

echo.
echo Generando AAB firmado...
call gradlew bundleRelease

echo.
echo Verificando resultado...
if exist "app\build\outputs\bundle\release\app-release.aab" (
    echo ✓ AAB generado exitosamente!
    echo Ubicación: app\build\outputs\bundle\release\app-release.aab
    echo.
    echo El archivo AAB está listo para subir a Google Play Store.
) else (
    echo ✗ Error: No se pudo generar el AAB
    pause
    exit /b 1
)

pause
