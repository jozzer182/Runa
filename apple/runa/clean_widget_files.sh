#!/bin/bash

# Script para limpiar archivos auto-generados por Xcode que causan conflictos
# Ejecutar desde la carpeta del proyecto

echo "🧹 Limpiando archivos auto-generados de Xcode..."

# Eliminar archivos no necesarios del widget
if [ -f "RunaWidget/RunaWidgetControl.swift" ]; then
    rm "RunaWidget/RunaWidgetControl.swift"
    echo "✅ Eliminado RunaWidgetControl.swift"
fi

if [ -f "RunaWidget/RunaWidgetLiveActivity.swift" ]; then
    rm "RunaWidget/RunaWidgetLiveActivity.swift"
    echo "✅ Eliminado RunaWidgetLiveActivity.swift"
fi

if [ -f "RunaWidget/AppIntent.swift" ]; then
    rm "RunaWidget/AppIntent.swift"
    echo "✅ Eliminado AppIntent.swift"
fi

# Limpiar DerivedData
echo "🗑️ Limpiando DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/runa-* 2>/dev/null || true

echo "✨ Limpieza completada"
echo "📝 Ahora puedes compilar el proyecto en Xcode"
echo "   1. Product → Clean Build Folder (Cmd+Shift+K)"
echo "   2. Product → Build (Cmd+B)"
