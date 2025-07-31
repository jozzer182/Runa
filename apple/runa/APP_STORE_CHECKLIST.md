# 📱 Checklist para subir RunaInspiracion a la App Store

## ✅ **PASO 1: Verificaciones Técnicas**

### **A. Configuración del Proyecto**
- [ ] **Bundle Identifier único**: `com.josezarabanda.runainspiracion`
- [ ] **Versión**: 1.0.0 (CFBundleShortVersionString)
- [ ] **Build Number**: 1 (CFBundleVersion)
- [ ] **Display Name**: "RunaInspiracion"
- [ ] **Minimum iOS Version**: 14.0+
- [ ] **Supported Devices**: iPhone, iPad
- [ ] **Orientations**: Portrait (recomendado para primera versión)

### **B. App Icons**
- [ ] **App Icon Set completo** en Assets.xcassets:
  - 20x20 pt (40x40 px, 60x60 px)
  - 29x29 pt (58x58 px, 87x87 px)  
  - 40x40 pt (80x80 px, 120x120 px)
  - 60x60 pt (120x120 px, 180x180 px)
  - 76x76 pt (152x152 px) - iPad
  - 83.5x83.5 pt (167x167 px) - iPad Pro
  - 1024x1024 px - App Store

### **C. Widget Configuration**
- [ ] **Widget Bundle ID**: `com.josezarabanda.runainspiracion.RunaWidget`
- [ ] **App Groups**: `group.com.josezarabanda.runainspiracion`
- [ ] **Widget funciona correctamente**
- [ ] **Widget se actualiza automáticamente**

## ✅ **PASO 2: Apple Developer Account**

### **A. Membresía**
- [ ] **Apple Developer Program**: $99/año activo
- [ ] **Cuenta verificada** y en buen estado

### **B. Certificates & Identifiers**
- [ ] **App ID registrado**: `com.josezarabanda.runainspiracion`
- [ ] **Widget App ID registrado**: `com.josezarabanda.runainspiracion.RunaWidget`
- [ ] **App Group registrado**: `group.com.josezarabanda.runainspiracion`
- [ ] **Distribution Certificate** creado
- [ ] **Provisioning Profiles** para distribución

### **C. App Store Connect**
- [ ] **App creada** en App Store Connect
- [ ] **Bundle ID asignado**
- [ ] **Información básica** completada

## ✅ **PASO 3: Metadata de la App**

### **A. Información Básica**
- [ ] **Nombre de la App**: "RunaInspiracion - Frases Motivacionales"
- [ ] **Subtítulo**: "Inspiración diaria con IA"
- [ ] **Categoría Principal**: Estilo de vida o Productividad
- [ ] **Categoría Secundaria**: Salud y fitness
- [ ] **Palabras clave**: "motivación, frases, inspiración, widget, IA, gemini"

### **B. Descripción**
```
🌟 RunaInspiracion - Tu dosis diaria de motivación

Transforma tu día con frases inspiradoras generadas por inteligencia artificial. RunaInspiracion te acompaña en tu journey personal con motivación constante.

✨ CARACTERÍSTICAS PRINCIPALES:
• Frases motivacionales únicas generadas por IA
• Widget para tu pantalla principal - motivación siempre visible
• Sincronización en tiempo real
• Interfaz elegante y minimalista
• Funciona offline con frases guardadas

🎯 PERFECTO PARA:
• Emprendedores que buscan inspiración diaria
• Personas en crecimiento personal
• Estudiantes que necesitan motivación
• Cualquiera que quiera comenzar el día con energía positiva

📱 WIDGET INCLUIDO:
Mantén la motivación siempre visible en tu pantalla principal. El widget se actualiza automáticamente con nuevas frases inspiradoras.

💡 POWERED BY AI:
Utilizamos inteligencia artificial avanzada para generar frases únicas y personalizadas que realmente conecten contigo.

Descarga RunaInspiracion hoy y comienza tu transformación personal. ¡Tu mejor versión te está esperando!
```

### **C. Screenshots**
- [ ] **iPhone 6.7"** (iPhone 15 Pro Max): 3 screenshots mínimo
- [ ] **iPhone 6.1"** (iPhone 15): 3 screenshots mínimo  
- [ ] **iPad Pro 12.9"**: 3 screenshots mínimo
- [ ] **Mostrar widget** en acción
- [ ] **Pantalla principal** de la app
- [ ] **Vista de configuración** del widget

### **D. App Preview (Video)**
- [ ] **Video de 15-30 segundos** mostrando funcionalidad
- [ ] **Mostrar widget** en pantalla principal
- [ ] **Demo de generación** de frases

## ✅ **PASO 4: Aspectos Legales**

### **A. Políticas de Apple**
- [ ] **Privacy Policy** (URL requerida)
- [ ] **Terms of Service** (recomendado)
- [ ] **Cumple App Store Review Guidelines**
- [ ] **No usa APIs privadas**
- [ ] **No incluye contenido inapropiado**

### **B. Configuración de Privacidad**
- [ ] **Privacy Manifest** (PrivacyInfo.xcprivacy)
- [ ] **Data Collection practices** definidas
- [ ] **Third-party SDKs** declarados (Firebase, Realm)

### **C. Contenido y Age Rating**
- [ ] **Age Rating**: 4+ (sin contenido restringido)
- [ ] **Content warnings**: Ninguna
- [ ] **Tipo de contenido**: Informational

## ✅ **PASO 5: Testing Final**

### **A. Funcionalidad**
- [ ] **App funciona** en dispositivos físicos
- [ ] **Widget funciona** correctamente
- [ ] **Datos se sincronizan** entre app y widget
- [ ] **Funciona offline** con datos cached
- [ ] **No crashes** reportados

### **B. Performance**
- [ ] **Tiempo de carga** < 3 segundos
- [ ] **Uso de memoria** optimizado
- [ ] **Batería** no se agota excesivamente
- [ ] **Widget se actualiza** en tiempos esperados

### **C. Device Testing**
- [ ] **iPhone** (diferentes tamaños)
- [ ] **iPad** (si soportas)
- [ ] **iOS 14+** versiones
- [ ] **Diferentes orientaciones**

## ✅ **PASO 6: Preparación para Release**

### **A. Build Configuration**
- [ ] **Release configuration** seleccionada
- [ ] **Archive build** exitoso
- [ ] **Code signing** configurado para distribución
- [ ] **Bitcode enabled** (si es requerido)

### **B. TestFlight (Opcional pero recomendado)**
- [ ] **Build subido** a TestFlight
- [ ] **Testing interno** completado
- [ ] **Testing externo** con usuarios (opcional)
- [ ] **Feedback incorporado**

### **C. Submission**
- [ ] **Binary uploaded** to App Store Connect
- [ ] **Metadata completada**
- [ ] **Screenshots subidas**
- [ ] **Privacy questions** respondidas
- [ ] **Export compliance** declarada
- [ ] **Submitted for review**

## 📋 **Recursos Útiles**

### **Tools Necesarios**
- Xcode (latest version)
- Apple Configurator (for testing)
- Screenshot tools (Simulator, real devices)
- Image editing software (iconos)

### **Documentación Apple**
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

### **Timeline Estimado**
- **Preparación**: 2-3 días
- **Review Process**: 24-48 horas (promedio actual)
- **Total**: 3-5 días aproximadamente

## 🚀 **Notas Importantes**

1. **Unique Selling Point**: Tu app combina IA con widgets - destaca esto
2. **Keywords Strategy**: Enfócate en "widget motivacional", "frases IA", "inspiración diaria"
3. **Pricing**: Considera empezar gratis para ganar usuarios, luego freemium
4. **Updates**: Planea updates regulares para mantener engagement

---
*Creado para RunaInspiracion v1.0 - 31/7/2025*
