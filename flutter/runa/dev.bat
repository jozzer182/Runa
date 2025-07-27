@echo off
echo ================================
echo   RUNA - Development Script
echo ================================
echo.

echo Selecciona una opción:
echo.
echo [1] Ejecutar en Windows
echo [2] Ejecutar en Chrome (Web)
echo [3] Solo build para Windows
echo [4] Análisis de código
echo [5] Generar código de Realm
echo [6] Limpiar proyecto
echo.

set /p choice="Ingresa tu opción (1-6): "

if "%choice%"=="1" (
    echo.
    echo Ejecutando en Windows...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo.
    echo Ejecutando en Chrome...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo.
    echo Construyendo para Windows...
    flutter build windows
) else if "%choice%"=="4" (
    echo.
    echo Analizando código...
    flutter analyze
) else if "%choice%"=="5" (
    echo.
    echo Generando código de Realm...
    dart run realm generate
) else if "%choice%"=="6" (
    echo.
    echo Limpiando proyecto...
    flutter clean
    flutter pub get
    dart run realm generate
) else (
    echo.
    echo Opción inválida. Ejecutando en Windows por defecto...
    flutter run -d windows
)

pause
