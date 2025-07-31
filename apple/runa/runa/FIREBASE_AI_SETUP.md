# 🔥 Firebase AI Logic Setup - Instrucciones Específicas

## ⚠️ IMPORTANTE: Configurar Firebase AI Logic en Firebase Console

### 📋 Pasos OBLIGATORIOS en Firebase Console:

#### 1. Ir a Firebase AI Logic
1. Abre [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto **runaesp**
3. En el menú lateral, busca **"AI Logic"** o navega directamente a:
   `https://console.firebase.google.com/project/runaesp/ailogic`

#### 2. Configurar el Proveedor API
1. Haz clic en **"Get started"**
2. En el workflow de configuración:
   - ✅ **Selecciona "Gemini Developer API"** (recomendado para usuarios nuevos)
   - ❌ **NO selecciones "Vertex AI Gemini API"** (requiere facturación)
3. Firebase habilitará automáticamente las APIs necesarias
4. **NO necesitas crear o copiar ninguna API key** - Firebase lo maneja automáticamente

#### 3. Verificar la configuración
- La consola debe mostrar que las APIs están habilitadas
- Deberías ver "Gemini Developer API" como proveedor activo

### 🛠️ Dependencias en Xcode:

#### Agregar FirebaseAI a tu proyecto:
1. En Xcode: **File** → **Add Package Dependencies**
2. URL: `https://github.com/firebase/firebase-ios-sdk`
3. **IMPORTANTE:** En la lista de productos, asegúrate de seleccionar:
   - ✅ `FirebaseCore` (ya lo tienes)
   - ✅ `FirebaseFirestore` (ya lo tienes)
   - ✅ **`FirebaseAI`** ← ¡ESTE ES NUEVO Y NECESARIO!

### 🔑 Diferencias clave con implementaciones anteriores:

#### ❌ LO QUE NO DEBES HACER:
- No uses Google AI Studio API key directamente
- No hagas llamadas HTTP manuales a la API de Gemini
- No uses Vertex AI (requiere facturación)

#### ✅ LO QUE SÍ DEBES HACER:
- Usa Firebase AI Logic SDK (FirebaseAI)
- Inicializa con `.googleAI()` backend
- La autenticación se maneja automáticamente via GoogleService-Info.plist

### 📝 Código de implementación:

```swift
import FirebaseAI

// Inicializar Firebase AI Logic
let firebaseAI = FirebaseAI.firebaseAI(backend: .googleAI())

// Crear modelo
let model = firebaseAI.generativeModel(modelName: "gemini-2.5-flash")

// Usar el modelo
let response = try await model.generateContent("Tu prompt aquí")
```

### 🎯 Ventajas de Firebase AI Logic vs API directa:

1. **Sin gestión de API keys** - Firebase maneja la autenticación
2. **Integración nativa** - Funciona directamente con tu proyecto Firebase
3. **Mejor manejo de errores** - Errores más específicos y manejables
4. **Plan gratuito** - Gemini Developer API incluye uso gratuito
5. **Más seguro** - No expones API keys en tu código

### 🚨 Troubleshooting:

#### Si ves errores de compilación:
1. Verifica que `FirebaseAI` está instalado
2. Asegúrate de que `GoogleService-Info.plist` está en el target
3. Limpia y recompila el proyecto

#### Si ves errores de "API not enabled":
1. Ve a Firebase Console → AI Logic
2. Verifica que el proveedor está configurado
3. Asegúrate de haber completado el workflow de setup

#### Si ves errores de quota:
- Es normal en desarrollo intensivo
- El servicio fallback (frases locales) se activará automáticamente

### 📊 Comparación con tu implementación Flutter:

**Flutter (lo que ya funciona):**
```dart
_firebaseAI = FirebaseAI.googleAI();
_model = _firebaseAI!.generativeModel(model: 'gemini-2.0-flash');
```

**Swift iOS (nueva implementación):**
```swift
firebaseAI = FirebaseAI.firebaseAI(backend: .googleAI())
model = firebaseAI?.generativeModel(modelName: "gemini-2.5-flash")
```

¡La lógica es exactamente la misma!
