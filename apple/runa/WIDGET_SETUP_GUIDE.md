# Configuración del Widget de Runa - Guía de Implementación

## 📋 Archivos Creados

El widget se ha implementado con los siguientes archivos:

### Widget Extension
- `RunaWidget/RunaWidget.swift` - Widget principal
- `RunaWidget/RunaWidgetBundle.swift` - Bundle del widget
- `RunaWidget/WidgetProvider.swift` - Proveedor de datos
- `RunaWidget/RunaWidgetEntryView.swift` - Vista del widget
- `RunaWidget/Info.plist` - Configuración del widget
- `RunaWidget/RunaWidget.entitlements` - Entitlements del widget

### App Principal
- `runa/Services/WidgetDataService.swift` - Servicio compartido de datos
- `runa/Views/WidgetConfigView.swift` - Vista de configuración del widget
- `runa/runa.entitlements` - Entitlements de la app principal

## 🔧 Configuración en Xcode

### 1. Añadir Widget Extension Target

1. En Xcode, selecciona el proyecto `runa.xcodeproj`
2. Ve a **File > New > Target**
3. Selecciona **Widget Extension**
4. Configura:
   - Product Name: `RunaWidget`
   - Bundle Identifier: `com.josezarabanda.runa.RunaWidget`
   - Include Configuration Intent: **NO**
5. Haz clic en **Finish**

### 2. Mover Archivos del Widget

1. Arrastra todos los archivos de la carpeta `RunaWidget/` al target `RunaWidget` en Xcode
2. Asegúrate de que los archivos estén asociados solo al target `RunaWidget`

### 3. Configurar App Groups

#### En Apple Developer Portal:
1. Ve a **Certificates, Identifiers & Profiles**
2. Selecciona **Identifiers**
3. Crea un nuevo **App Group** con ID: `group.com.josezarabanda.runa`
4. Añade este App Group a:
   - El App ID de tu app principal (`com.josezarabanda.runa`)
   - El App ID del widget (`com.josezarabanda.runa.RunaWidget`)

#### En Xcode:
1. Selecciona el target de la **app principal**
2. Ve a **Signing & Capabilities**
3. Añade capability **App Groups**
4. Marca `group.com.josezarabanda.runa`

5. Repite para el target del **widget**

### 4. Configurar Entitlements

Los archivos `.entitlements` ya están creados. Solo necesitas:

1. En el target de la **app principal**:
   - Ve a **Build Settings**
   - Busca **Code Signing Entitlements**
   - Establece el valor: `runa/runa.entitlements`

2. En el target del **widget**:
   - Ve a **Build Settings**
   - Busca **Code Signing Entitlements**
   - Establece el valor: `RunaWidget/RunaWidget.entitlements`

### 5. Añadir URL Scheme (Opcional)

Para que el widget pueda abrir la app:

1. Selecciona el target de la **app principal**
2. Ve a **Info** tab
3. Expande **URL Types**
4. Añade nuevo URL Type:
   - Identifier: `com.josezarabanda.runa.urlscheme`
   - URL Schemes: `runa`

### 6. Compilar y Probar

1. Selecciona el scheme de la **app principal**
2. Compila y ejecuta
3. Luego selecciona el scheme del **widget** y ejecuta para probar el widget

## 📱 Uso del Widget

### Para los usuarios:

1. **Añadir widget a pantalla principal:**
   - Mantén presionado en la pantalla principal
   - Toca el botón "+" en la esquina superior izquierda
   - Busca "Runa" en la lista
   - Selecciona el tamaño deseado (Mediano o Grande)
   - Toca "Añadir Widget"

2. **Configurar desde la app:**
   - Abre la app Runa
   - Toca el ícono de widget (rectángulo apilado) en la esquina superior derecha
   - Usa los controles para actualizar el widget

### Funcionalidades del Widget:

- **Actualización automática**: Cada 4 horas
- **Sincronización**: Se actualiza cuando cambias la frase en la app
- **Datos compartidos**: Usa App Groups para sincronizar frases
- **Fallback**: Muestra frases por defecto si no hay conexión con la app
- **Tamaños**: Mediano (2x1) y Grande (2x2)

## 🔄 Sincronización de Datos

El widget se sincroniza automáticamente cuando:

1. La app genera una nueva frase
2. Se carga una frase desde Firestore
3. Se obtiene una frase local de Realm
4. El usuario actualiza manualmente desde la configuración

Los datos se almacenan en UserDefaults compartido usando el App Group.

## 🐛 Resolución de Problemas

### Errores de compilación "Invalid redeclaration of 'Provider'":
1. **Limpiar archivos auto-generados por Xcode:**
   ```bash
   # Eliminar archivos no necesarios que Xcode puede haber creado
   rm RunaWidget/RunaWidgetControl.swift
   rm RunaWidget/RunaWidgetLiveActivity.swift
   rm RunaWidget/AppIntent.swift
   ```

2. **Limpiar DerivedData:**
   ```bash
   # Desde la carpeta del proyecto
   rm -rf ~/Library/Developer/Xcode/DerivedData/runa-*
   ```

3. **En Xcode:**
   - Product → Clean Build Folder (Cmd+Shift+K)
   - Product → Build (Cmd+B)

### Widget no aparece en la lista:
- Verifica que el target del widget se compiló correctamente
- Asegúrate de que los App Groups están configurados
- Reinstala la app en el dispositivo

### Widget no se actualiza:
- Verifica que el App Group ID sea correcto en ambos targets
- Comprueba que los entitlements estén configurados
- Usa la función "Actualizar Widget" en la configuración

### Errores de compilación:
- Asegúrate de que WidgetKit está importado en todos los archivos del widget
- Verifica que los targets están configurados correctamente
- Comprueba que las dependencias estén correctas

## 📝 Notas Adicionales

- El widget funciona tanto en modo online como offline
- Las frases se limitan a 200 caracteres para optimizar la visualización
- Se almacenan máximo 50 frases en el widget
- El diseño se adapta automáticamente al tamaño del widget
- Compatible con iOS 14.0+
