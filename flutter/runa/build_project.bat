@echo off
echo ================================
echo    RUNA - Build Script
echo ================================
echo.

echo [1/4] Limpiando proyecto...
flutter clean

echo.
echo [2/4] Obteniendo dependencias...
flutter pub get

echo.
echo [3/4] Generando código de Realm...
dart run realm generate

echo.
echo [4/4] Analizando código...
flutter analyze

echo.
echo ================================
echo ¡Proyecto listo!
echo ================================
echo.
echo Para ejecutar la aplicación:
echo   flutter run -d windows
echo   flutter run -d chrome
echo.
pause
