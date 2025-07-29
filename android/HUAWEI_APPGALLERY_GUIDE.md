# Guía de Publicación - Runa en Huawei AppGallery

## 📱 Información del APK

**Archivo listo para subir:** `app\build\outputs\apk\release\runa-huawei-appgallery-v1.0.apk`
- **Tamaño:** 47.17 MB
- **Package Name:** com.zarabandajose.runa
- **Version Code:** 1
- **Version Name:** 1.0
- **Min SDK:** Android 7.0 (API 24)
- **Target SDK:** Android 14 (API 36)

## 🏪 Proceso de Publicación en Huawei AppGallery

### 1. Acceso a Developer Console
- URL: https://developer.huawei.com/consumer/en/console
- Inicia sesión con tu cuenta de desarrollador Huawei
- Si no tienes cuenta, regístrate como desarrollador

### 2. Información Básica de la Aplicación

**Metadatos requeridos:**
```
Nombre de la aplicación: Runa - Motivación Diaria
Categoría: Lifestyle / Health & Fitness
Idiomas: Español (España)
Descripción corta: Tu dosis diaria de motivación con frases inspiradoras
País/Región de publicación: España, México, Argentina, Colombia, etc.
```

**Descripción larga sugerida:**
```
Runa es tu compañero diario para la motivación y el crecimiento personal. 

✨ CARACTERÍSTICAS PRINCIPALES:
• Frases motivacionales generadas por IA personalizada
• Contenido offline para acceso sin conexión
• Interfaz moderna y minimalista
• Sincronización en la nube
• Recordatorios diarios personalizables

🎯 PARA QUÉ ES IDEAL:
• Comenzar el día con energía positiva
• Superar momentos difíciles
• Mantener la motivación en tus proyectos
• Crecimiento personal y mindfulness

🔐 PRIVACIDAD Y SEGURIDAD:
• No recopila datos personales sensibles
• Funciona completamente offline
• Compatible con dispositivos Huawei y Honor
• Optimizada para HMS Core

Transforma tu mentalidad, un día a la vez con Runa.
```

### 3. Especificaciones Técnicas

**Permisos principales:**
- `INTERNET` - Para sincronización con Firebase
- `ACCESS_NETWORK_STATE` - Para verificar conectividad
- `WAKE_LOCK` - Para notificaciones programadas

**Compatibilidad:**
- ✅ Dispositivos Huawei/Honor
- ✅ HMS Core compatible
- ✅ No requiere Google Play Services
- ✅ Funciona offline
- ✅ Android 7.0+

### 4. Recursos Visuales Requeridos

**Iconos de aplicación:**
- Icono principal: 512x512 px (PNG)
- Icono de notificación: 24x24, 48x48, 96x96 px

**Capturas de pantalla:**
- Mínimo 3, máximo 10 capturas
- Resolución: 1080x1920 px (ratio 9:16)
- Formatos: PNG o JPG

**Banner promocional (opcional):**
- Tamaño: 1024x500 px
- Formato: PNG o JPG

### 5. Información del Desarrollador

```
Desarrollador: ZarabandaJose
Email de contacto: [tu-email]
Sitio web: [opcional]
Política de privacidad: [requerida para apps que usan internet]
```

### 6. Configuración de Distribución

**Precio:** Gratuita
**Países:** España, México, Argentina, Colombia, Perú, Chile, etc.
**Dispositivos:** Todos los compatibles con Android 7.0+
**Edad mínima:** 3+ (contenido apto para todas las edades)

## 🔧 Características Específicas para Huawei

### Compatibilidad HMS
- ✅ La aplicación NO usa Google Play Services
- ✅ Usa Firebase que es compatible con HMS
- ✅ Funciona en dispositivos sin GMS
- ✅ Optimizada para el ecosistema Huawei

### Funcionalidades Offline
- ✅ Base de datos local con Realm
- ✅ Frases precargadas para uso sin conexión
- ✅ Sincronización automática cuando hay red
- ✅ Experiencia completa sin internet

## 📋 Checklist de Publicación

### Antes de Subir:
- [ ] APK firmado y verificado
- [ ] Descripción y metadatos preparados
- [ ] Capturas de pantalla tomadas
- [ ] Política de privacidad redactada
- [ ] Cuenta de desarrollador verificada

### Durante la Subida:
- [ ] Subir APK: `runa-huawei-appgallery-v1.0.apk`
- [ ] Completar información básica
- [ ] Subir recursos visuales
- [ ] Configurar distribución
- [ ] Revisar permisos automáticamente detectados

### Después de la Subida:
- [ ] Revisar información en preview
- [ ] Enviar para revisión
- [ ] Esperar aprobación (normalmente 1-3 días)
- [ ] Publicar tras aprobación

## ⚠️ Consideraciones Importantes

1. **Política de Privacidad:** Aunque la app es offline-first, usa Firebase, por lo que necesitas una política de privacidad.

2. **Localización:** La app está en español, asegúrate de seleccionar los países hispanohablantes apropiados.

3. **Actualizaciones:** Para futuras versiones, incrementa `versionCode` y `versionName` en `build.gradle.kts`.

4. **Testing:** Huawei puede probar la app en dispositivos reales, asegúrate de que funcione sin Google Play Services.

## 🚀 Tiempo Estimado de Publicación

- **Subida y configuración:** 30-60 minutos
- **Revisión de Huawei:** 1-3 días hábiles
- **Publicación:** Inmediata tras aprobación

## 📞 Soporte

Si encuentras problemas durante la publicación:
- Documentación oficial: https://developer.huawei.com/consumer/en/doc/AppGallery-connect
- Soporte de desarrollador: A través del Developer Console
- Comunidad: Huawei Developer Forums
