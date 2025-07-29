# Runa - Aplicación de Frases Motivacionales

**Runa** es una aplicación Flutter que proporciona frases motivacionales diarias a los usuarios. La aplicación está diseñada para funcionar tanto online como offline, con una arquitectura robusta que integra múltiples fuentes de datos.

## 🏗️ Arquitectura

La aplicación sigue el patrón **MVC (Model-View-Controller)** con servicios especializados:

### 📁 Estructura del Proyecto

```
lib/
├── models/
│   ├── phrase.dart          # Modelo de datos para frases (Realm)
│   └── phrase.realm.dart    # Código generado de Realm
├── services/
│   ├── realm_service.dart   # Gestión de base de datos local
│   ├── firestore_service.dart # Gestión de Firebase Firestore
│   └── gemini_service.dart  # Integración con Gemini AI
├── controllers/
│   └── phrase_controller.dart # Lógica de negocio principal
├── views/
│   └── phrase_view.dart     # Interfaz de usuario
└── main.dart               # Punto de entrada de la aplicación
```

## 🔄 Flujo de Datos

La aplicación sigue el siguiente flujo según el diagrama proporcionado:

1. **Inicialización**: Verifica si existe una base de datos Realm local
2. **Carga Inicial**: Si no existe, carga las frases base desde `assets/base_phrases.json`
3. **Generación IA**: Intenta generar nueva frase con Gemini AI
4. **Fallback Firestore**: Si Gemini falla, busca en Firestore
5. **Fallback Local**: Si Firestore falla, usa frases locales de Realm
6. **Mensaje de Error**: Si todo falla, muestra mensaje al usuario

## 🗄️ Gestión de Datos

### Base de Datos Local (Realm)
- Almacena frases persistentemente para funcionamiento offline
- Rastrea qué frases han sido mostradas y cuándo
- Esquema: `id`, `text`, `createdAt`, `source`, `isShown`, `lastShownAt`

### Firebase Firestore
- Respaldo en la nube para frases generadas por IA
- Permite sincronización entre dispositivos (futuro)
- Funciona como fallback cuando Gemini no está disponible

### Gemini AI (Simulado)
- Genera frases motivacionales nuevas
- Implementado con simulación para pruebas
- Fácil de reemplazar con la API real de Firebase AI

## 🎨 Interfaz de Usuario

### Características del Diseño
- **Diseño Limpio**: Interfaz minimalista y elegante
- **Responsive**: Adaptable para escritorio y móvil
- **Animaciones Suaves**: Transiciones fluidas entre frases
- **Accesibilidad**: Botones claramente etiquetados

### Funcionalidades
- **Frase del Día**: Muestra una frase motivacional
- **Navegación**: Toca la frase para obtener la siguiente
- **Copiar**: Botón para copiar frase al portapapeles
- **Recargar**: Botón para forzar nueva frase
- **Indicador de Fuente**: Muestra el origen de la frase (IA, nube, local)

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.15.2      # Core de Firebase
  firebase_ai: ^2.3.0         # Gemini AI (futuro)
  cloud_firestore: ^5.6.0     # Base de datos en la nube
  realm: ^20.0.0               # Base de datos local
  connectivity_plus: ^6.0.0   # Detección de conectividad
  shared_preferences: ^2.2.0  # Preferencias del usuario
  http: ^1.1.0                # Peticiones HTTP
  intl: ^0.19.0               # Internacionalización
```

## 🚀 Instalación y Configuración

### Requisitos Previos
- Flutter SDK 3.7.2 o superior
- Dart SDK 3.7.2 o superior
- Firebase Project configurado

### Pasos de Instalación

1. **Clonar e instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Generar código de Realm**:
   ```bash
   dart run realm generate
   ```

3. **Configurar Firebase** (opcional para pruebas):
   - Crear proyecto en Firebase Console
   - Configurar Firestore
   - Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)

4. **Ejecutar la aplicación**:
   ```bash
   flutter run -d windows  # Para Windows
   flutter run -d chrome   # Para Web
   ```

## 🔧 Configuración

### Frases Base
Las frases iniciales están en `assets/base_phrases.json` con el formato:
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

### Configuración de Firebase
Para usar las funcionalidades completas de Firebase:
1. Configurar proyecto en Firebase Console
2. Habilitar Firestore
3. Configurar Firebase AI/Gemini (cuando esté disponible)
4. Actualizar `firebase_options.dart`

## 🎯 Funcionalidades Futuras

### Versión 1.1
- [ ] Integración real con Gemini AI
- [ ] Notificaciones push diarias
- [ ] Configuración de horarios preferidos
- [ ] Más fuentes de frases (APIs externas)

### Versión 1.2
- [ ] Widget para escritorio
- [ ] Sincronización entre dispositivos
- [ ] Categorías de frases (motivación, amor, éxito, etc.)
- [ ] Historial de frases favoritas

### Versión 1.3
- [ ] Monetización con anuncios
- [ ] Modo premium sin anuncios
- [ ] Compartir en redes sociales
- [ ] Personalización de temas

## 📱 Plataformas Soportadas

- ✅ **Windows** (Principal)
- ✅ **Web** (Funcional)
- 🔄 **iOS** (Planeado para App Store)
- 🔄 **Android** (Futuro)

## 🐛 Solución de Problemas

### Error de Compilación de Realm
```bash
dart run realm generate
flutter clean
flutter pub get
```

### Problemas de Firebase
- Verificar que `firebase_options.dart` existe
- Confirmar configuración de proyecto Firebase
- Revisar permisos de Firestore

### Problemas de Conectividad
- La app funciona offline con frases locales
- Verificar configuración de red en emulador

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crear una rama para la funcionalidad (`git checkout -b feature/AmazingFeature`)
3. Commit los cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📞 Soporte

Para reportar bugs o solicitar funcionalidades, por favor usar el sistema de Issues de GitHub.

---

**Desarrollado con ❤️ para inspirar y motivar cada día**
