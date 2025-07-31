# Runa iOS - Dependencias requeridas

Este archivo contiene las dependencias que necesitas agregar a tu proyecto Xcode.

## Dependencias requeridas en Xcode:

### 1. Firebase SDK
Ya tienes Firebase configurado, pero asegúrate de tener estos módulos:
- FirebaseCore
- FirebaseFirestore
- **FirebaseAI** (para Firebase AI Logic / Gemini)
- FirebaseAuth (opcional para futuras funcionalidades)

### 2. Realm Swift
Necesitas agregar Realm para la base de datos local:
- RealmSwift

### 3. Para agregar dependencias en Xcode:
1. Ve a File → Add Package Dependencies
2. Agrega las siguientes URLs:

**Realm Swift:**
```
https://github.com/realm/realm-swift
```

**Firebase (si no está agregado):**
```
https://github.com/firebase/firebase-ios-sdk
```

**⚠️ IMPORTANTE:** Al agregar Firebase, asegúrate de seleccionar también **FirebaseAI** para Firebase AI Logic.

### 4. Configuración adicional requerida:

#### A. Agregar el archivo GoogleService-Info.plist
1. Descarga el archivo desde Firebase Console
2. Arrástralo a tu proyecto Xcode
3. Asegúrate de que esté incluido en el target

#### B. Configurar el archivo base_phrases.json en Xcode
1. Selecciona el archivo base_phrases.json en el navegador de proyecto
2. En el inspector de archivos (lado derecho), asegúrate de que esté marcado para el target de tu app

#### C. Configurar Firebase AI Logic (Gemini)
1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto
3. Ve a la página **Firebase AI Logic**
4. Haz clic en **Get started** y sigue el workflow
5. **IMPORTANTE:** Selecciona **"Gemini Developer API"** (no Vertex AI)
6. La consola habilitará las APIs necesarias y creará la clave automáticamente
7. **NO agregues** ninguna API key a tu código - Firebase AI Logic lo maneja automáticamente

### 5. Permisos (Info.plist)
Agrega estas claves a tu Info.plist si planeas usar funcionalidades adicionales:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 6. Próximos pasos después de instalar dependencias:

1. ✅ Agregar dependencias de Realm y Firebase
2. ✅ Configurar GoogleService-Info.plist
3. ✅ Agregar base_phrases.json al target
4. ✅ Configurar API key de Gemini
5. ✅ Compilar y probar la aplicación

### 7. Funcionalidades implementadas:

- ✅ Inicialización automática de Realm con frases base
- ✅ Jerarquía de obtención de frases (Gemini → Firestore → Realm → Error)
- ✅ UI adaptable con animaciones
- ✅ Manejo de estados de conexión
- ✅ Funcionalidad de compartir frases
- ✅ Diseño responsive para diferentes tamaños de pantalla
- ✅ Feedback háptico para interacciones
- ✅ Sistema de actualización automática cada 24 horas

### 8. Arquitectura del proyecto:

```
runa/
├── Models/
│   └── Phrase.swift (Modelo de datos con Realm)
├── Services/
│   ├── RealmService.swift (Base de datos local)
│   ├── FirestoreService.swift (Base de datos remota)
│   └── GeminiService.swift (Generación de frases con IA)
├── Controllers/
│   └── PhraseController.swift (Lógica de negocio)
├── Views/
│   └── PhraseView.swift (UI principal)
├── base_phrases.json (30 frases base)
└── Assets/... (Iconos de la app)
```

La aplicación está lista para funcionar una vez que instales las dependencias necesarias.
