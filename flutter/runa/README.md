# Runa 🌟 - Aplicación de Frases Motivacionales

**Runa** es una aplicación Flutter que proporciona frases motivacionales diarias para inspirar y motivar a los usuarios. Diseñada inicialmente para Windows con planes de expansión a iOS y otras plataformas.

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.7.2+-blue?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange?logo=firebase)
![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Web%20|%20iOS%20(planned)-green)

## ✨ Características Principales

- 🎯 **Frase Diaria Motivacional**: Una nueva frase inspiradora cada día
- 🤖 **IA Integrada**: Generación de frases usando Gemini AI (simulado)
- 📱 **Diseño Adaptativo**: Funciona en escritorio y dispositivos móviles
- 🔄 **Funcionamiento Offline**: Base de datos local con Realm
- ☁️ **Sincronización en la Nube**: Backup con Firebase Firestore
- 📋 **Copiar y Compartir**: Fácil copia de frases al portapapeles
- 🎨 **Interfaz Elegante**: Diseño limpio y animaciones suaves

## 🚀 Inicio Rápido

### Prerrequisitos

- [Flutter SDK 3.7.2+](https://flutter.dev/docs/get-started/install)
- [Dart SDK 3.7.2+](https://dart.dev/get-dart)
- Windows 10+ (para desarrollo en Windows)

### Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone <tu-repo>
   cd runa
   ```

2. **Ejecutar script de construcción**:
   ```batch
   build_project.bat
   ```

   O manualmente:
   ```bash
   flutter pub get
   dart run realm generate
   flutter analyze
   ```

3. **Ejecutar la aplicación**:
   ```batch
   dev.bat
   ```

   O manualmente:
   ```bash
   flutter run -d windows    # Para Windows
   flutter run -d chrome     # Para Web
   ```

## 🏗️ Arquitectura

La aplicación sigue una arquitectura **MVC** con servicios especializados:

```
📁 lib/
├── 📁 models/              # Modelos de datos (Realm)
├── 📁 services/            # Servicios (Realm, Firestore, Gemini)
├── 📁 controllers/         # Lógica de negocio
├── 📁 views/               # Interfaz de usuario
└── 📄 main.dart           # Punto de entrada
```

### 🔄 Flujo de Datos

1. **Inicialización** → Verifica BD Realm local
2. **Carga Base** → Importa frases desde JSON si es necesario
3. **Generación IA** → Intenta crear frase con Gemini
4. **Fallback Firestore** → Si Gemini falla, consulta la nube
5. **Fallback Local** → Si todo falla, usa frases locales
6. **UI** → Muestra frase con animaciones

## 🛠️ Tecnologías Utilizadas

| Tecnología | Propósito | Estado |
|------------|-----------|---------|
| **Flutter** | Framework de UI multiplataforma | ✅ Implementado |
| **Realm** | Base de datos local persistente | ✅ Implementado |
| **Firebase Firestore** | Base de datos en la nube | ✅ Implementado |
| **Firebase AI (Gemini)** | Generación de frases IA | 🔄 Simulado |
| **Connectivity Plus** | Detección de conectividad | ✅ Implementado |
| **Shared Preferences** | Configuraciones locales | ✅ Implementado |

## 📦 Estructura de Datos

### Modelo de Frase
```dart
class Phrase {
  int id;              // ID único
  String text;         // Texto de la frase
  DateTime? createdAt; // Fecha de creación
  String source;       // 'base', 'gemini', 'firestore'
  bool isShown;        // Si ya fue mostrada
  DateTime? lastShownAt; // Última vez mostrada
}
```

### Archivo de Frases Base
```json
{
  "phrases": [
    {
      "id": 1,
      "text": "Hoy es un buen día para comenzar de nuevo.",
      "createdAt": null,
      "source": "base"
    }
  ]
}
```

## 🔧 Scripts Disponibles

| Script | Comando | Descripción |
|--------|---------|-------------|
| **Desarrollo** | `dev.bat` | Menu interactivo de desarrollo |
| **Build** | `build_project.bat` | Construcción completa del proyecto |
| **Análisis** | `flutter analyze` | Análisis de código |
| **Generar Realm** | `dart run realm generate` | Regenerar modelos de Realm |

## 🎯 Estado del Proyecto

### ✅ Completado (v1.0)
- [x] Interfaz básica funcional
- [x] Base de datos local (Realm)
- [x] Simulación de IA para frases
- [x] Funcionamiento offline
- [x] Arquitectura escalable

### 🔄 En Desarrollo (v1.1)
- [ ] Integración real con Gemini AI
- [ ] Notificaciones push diarias
- [ ] Configuración de horarios
- [ ] Más categorías de frases

### 📋 Planificado (v1.2+)
- [ ] Widget para escritorio
- [ ] Sincronización entre dispositivos
- [ ] Historial de frases favoritas
- [ ] Monetización con anuncios

## 🐛 Solución de Problemas

### Error de Compilación Realm
```bash
dart run realm generate
flutter clean
flutter pub get
```

### App no inicia
1. Verificar Flutter: `flutter doctor`
2. Limpiar proyecto: `flutter clean`
3. Reinstalar dependencias: `flutter pub get`

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**.

---

<div align="center">

**¡Gracias por usar Runa! 🌟**

*Cada día es una nueva oportunidad para crecer y motivarse.*

</div>
4. Run `flutterfire configure` and select your Firebase project
5. This will automatically update your `firebase_options.dart` file with the correct configuration

### Running the Project

```bash
flutter pub get
flutter run
```

## Features

- Firebase Authentication
- Gemini AI Integration
- Cross-platform support (Windows, Android, iOS, Web)

## Security Note

The `firebase_options.dart` file is excluded from version control for security reasons. You'll need to configure it locally using the steps above.
