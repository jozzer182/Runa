#!/bin/bash

# 🚀 Script de preparación para App Store - Runa
# Ejecutar antes de hacer el archive para distribución

echo "🚀 Preparando Runa para App Store..."
echo "=================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para verificar archivos
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 encontrado${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 NO encontrado${NC}"
        return 1
    fi
}

# Función para verificar directorios
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅ $1 encontrado${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 NO encontrado${NC}"
        return 1
    fi
}

echo -e "${BLUE}📋 Verificando archivos requeridos...${NC}"
echo ""

# Verificar archivos esenciales
files_ok=true

echo "🎨 Icons:"
if ! check_file "runa/Assets.xcassets/AppIcon.appiconset/1024.png"; then
    files_ok=false
fi

echo ""
echo "📱 Project files:"
if ! check_file "runa.xcodeproj/project.pbxproj"; then
    files_ok=false
fi

if ! check_file "runa/GoogleService-Info.plist"; then
    files_ok=false
fi

echo ""
echo "🔧 Widget files:"
if ! check_file "RunaWidget/RunaWidget.swift"; then
    files_ok=false
fi

if ! check_file "runa/Services/WidgetDataService.swift"; then
    files_ok=false
fi

echo ""
echo "📋 Documentation:"
if ! check_file "privacy_policy.html"; then
    files_ok=false
fi

if ! check_file "APP_STORE_CHECKLIST.md"; then
    files_ok=false
fi

echo ""
echo -e "${BLUE}🔍 Verificando configuración del proyecto...${NC}"

# Verificar que existe el scheme principal
if xcodebuild -list | grep -q "runa"; then
    echo -e "${GREEN}✅ Scheme 'runa' encontrado${NC}"
else
    echo -e "${RED}❌ Scheme 'runa' NO encontrado${NC}"
    files_ok=false
fi

# Verificar que existe el scheme del widget
if xcodebuild -list | grep -q "RunaWidgetExtension"; then
    echo -e "${GREEN}✅ Widget Extension encontrado${NC}"
else
    echo -e "${RED}❌ Widget Extension NO encontrado${NC}"
    files_ok=false
fi

echo ""
echo -e "${BLUE}🧪 Probando compilación...${NC}"

# Test build
if xcodebuild -scheme runa -configuration Release -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' build > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Compilación exitosa${NC}"
else
    echo -e "${RED}❌ Error de compilación${NC}"
    echo -e "${YELLOW}Ejecuta: xcodebuild -scheme runa -configuration Release build${NC}"
    files_ok=false
fi

echo ""
echo "=================================="

if [ "$files_ok" = true ]; then
    echo -e "${GREEN}🎉 ¡Todo listo para App Store!${NC}"
    echo ""
    echo -e "${BLUE}📋 Próximos pasos:${NC}"
    echo "1. 🎨 Completar iconos (todos los tamaños)"
    echo "2. 📱 Configurar versión (1.0.0) y build (1)"
    echo "3. 🔐 Configurar signing para distribución"
    echo "4. 📦 Crear archive desde Xcode"
    echo "5. 🚀 Subir a App Store Connect"
    echo ""
    echo -e "${YELLOW}💡 Tip: Abre APP_STORE_CHECKLIST.md para detalles completos${NC}"
else
    echo -e "${RED}❌ Hay problemas que resolver antes de continuar${NC}"
    echo -e "${YELLOW}Revisa los errores arriba y corrige antes de proceder${NC}"
fi

echo ""
echo "🔗 Recursos útiles:"
echo "   • App Store Connect: https://appstoreconnect.apple.com"
echo "   • Review Guidelines: https://developer.apple.com/app-store/review/guidelines/"
echo "   • Icon Generator: https://appicon.co"
echo ""
