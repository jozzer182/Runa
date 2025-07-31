#!/bin/bash

# Script para crear iconos de app para Runa
# Ejecutar desde la raíz del proyecto

echo "🎨 Generando iconos para Runa..."

# Crear directorio temporal para iconos
mkdir -p temp_icons

# Tamaños requeridos para iOS
SIZES=(
    "20x20"
    "29x29" 
    "40x40"
    "58x58"
    "60x60"
    "76x76"
    "80x80"
    "87x87"
    "120x120"
    "152x152"
    "167x167"
    "180x180"
    "1024x1024"
)

echo "📝 Tamaños de iconos requeridos:"
for size in "${SIZES[@]}"; do
    echo "  - $size"
done

echo ""
echo "🛠️  Instrucciones para crear iconos:"
echo "1. Crea un diseño de 1024x1024 px para tu app"
echo "2. Elementos sugeridos para Runa:"
echo "   - Símbolo de motivación (rayo, estrella, montaña)"
echo "   - Colores: gradient similar al de tu app"
echo "   - Tipografía: 'Runa' o símbolo representativo"
echo "   - Estilo: moderno, minimalista"
echo ""
echo "3. Usa herramientas como:"
echo "   - AppIcon.co (online, automático)"
echo "   - Sketch + App Icon plugin"
echo "   - Figma + Icon generator"
echo "   - Adobe Illustrator"
echo ""
echo "4. Exporta todos los tamaños y colócalos en:"
echo "   Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "💡 Tip: El icono debe verse bien tanto en tamaño pequeño como grande"
echo "💡 Tip: Evita texto muy pequeño que no se lea en tamaños reducidos"

# Crear estructura de carpetas si no existe
if [ ! -d "Assets.xcassets/AppIcon.appiconset" ]; then
    echo "📁 Creando estructura de AppIcon..."
    mkdir -p Assets.xcassets/AppIcon.appiconset
fi

echo ""
echo "✅ Listo para agregar iconos a Assets.xcassets/AppIcon.appiconset/"
