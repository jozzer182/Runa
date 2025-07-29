# Scripts de Automatización - Runa

Este documento describe los scripts PowerShell utilizados para compilar y empaquetar la aplicación Runa para diferentes plataformas. **Estos scripts no están incluidos en el repositorio por motivos de seguridad.**

## 🔒 Seguridad

Los archivos `.ps1` contienen:
- Contraseñas de keystores
- Rutas específicas del sistema
- Configuraciones de certificados
- Información sensible de compilación

**Por eso están excluidos del repositorio en `.gitignore`**

## 📱 Scripts de Android

### `build_huawei_apk.ps1`
- **Propósito:** Compilar APK firmado para Huawei AppGallery
- **Funciones:**
  - Genera keystore automáticamente si no existe
  - Compila APK de release firmado
  - Optimiza para dispositivos Huawei/Honor
  - Verifica compatibilidad HMS Core

### `verify_apk.ps1`
- **Propósito:** Verificar la integridad del APK generado
- **Funciones:**
  - Valida firma digital
  - Verifica metadatos del APK
  - Confirma compatibilidad con AppGallery

## 🪟 Scripts de Windows (Flutter)

### `create_store_certified_msix.ps1`
- **Propósito:** Crear paquete MSIX para Microsoft Store
- **Funciones:**
  - Compila Flutter para Windows
  - Genera MSIX firmado para Store
  - Valida certificación de Store

### `validate_store_msix.ps1`
- **Propósito:** Validar paquete MSIX antes de subir a Store
- **Funciones:**
  - Verifica certificado de Store
  - Valida manifiesto
  - Confirma requisitos de Store

### Otros scripts MSIX:
- `create_signed_msix.ps1` - MSIX con certificado de desarrollador
- `create_optimized_msix.ps1` - MSIX optimizado para distribución
- `create_test_certificate.ps1` - Certificado de prueba
- `install_runa.ps1` - Instalación local para testing

## 🔧 Scripts de Configuración

### `setup_github_privacy.ps1`
- **Propósito:** Preparar documentos de privacidad para GitHub Pages
- **Funciones:**
  - Verifica archivos de política de privacidad
  - Prepara documentos para GitHub Pages
  - Genera URLs públicas para stores

## 🚀 Cómo Recrear los Scripts

Si necesitas recrear estos scripts, aquí están las funciones principales que deben incluir:

### Para Android (Huawei):
```powershell
# 1. Crear keystore con keytool
# 2. Configurar gradle.properties con credenciales
# 3. Ejecutar ./gradlew assembleRelease
# 4. Firmar APK con jarsigner
# 5. Optimizar con zipalign
```

### Para Windows (Microsoft Store):
```powershell
# 1. flutter build windows
# 2. Configurar msix con certificado de Store
# 3. Ejecutar flutter pub run msix:create
# 4. Validar con Windows App Certification Kit
```

## 📋 Configuración Requerida

### Variables de Entorno Necesarias:
- `JAVA_HOME` - Para keytool y jarsigner
- Certificados de Store en el almacén de Windows
- Flutter SDK configurado

### Archivos de Configuración:
- `keystore.properties` (Android)
- `firebase_options.dart` (Firebase)
- Certificados de Microsoft Store

## ⚠️ Importante

1. **Nunca subas keystores o certificados a git**
2. **Usa contraseñas seguras para keystores**
3. **Mantén copias de seguridad de certificados**
4. **Verifica siempre los APK/MSIX antes de distribuir**

## 🛠️ Herramientas Requeridas

- **Android:** Android SDK, Java JDK, Gradle
- **Windows:** Visual Studio, Windows SDK, Flutter
- **Certificados:** Store certificates, signing certificates
- **PowerShell:** Version 5.0 o superior

---

*Para más información sobre la configuración específica, consulta la documentación de cada plataforma (Huawei AppGallery, Microsoft Store).*
