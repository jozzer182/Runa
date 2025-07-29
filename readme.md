# 🌟 Runa - Motivación Diaria

**Tu dosis diaria de motivación con frases inspiradoras generadas por IA.**

Runa es una aplicación multiplataforma que proporciona frases motivacionales personalizadas en español, generadas dinámicamente por inteligencia artificial. Diseñada para funcionar offline y proteger tu privacidad, esta aplicación busca inspirar y conectar emocionalmente contigo en tu día a día.

## 📱 Disponible en

- 🛍️ **Huawei AppGallery** - [Próximamente]
- 🏪 **Microsoft Store** - [Próximamente]  
- 🤖 **Google Play Store** - [En desarrollo]

## 🔒 Privacidad y Datos

### Compromiso con la Privacidad
Runa está diseñada con **privacidad por diseño**:

- ❌ **NO recopilamos** datos personales identificables
- ❌ **NO accedemos** a contactos, ubicación o archivos personales
- ✅ **Funciona offline** - No requiere conexión constante
- ✅ **Datos locales** - Todo se almacena en tu dispositivo
- ✅ **Sin cuentas** - No requiere registro

### Documentos Legales
- 📜 [Política de Privacidad](./PRIVACY_POLICY.md)
- 📋 [Términos de Servicio](./TERMS_OF_SERVICE.md)
- 🌐 [Privacy Policy (Web)](https://jozzer182.github.io/Runa/privacy-policy.html)

---

## 🎯 Objetivo

Brindar una experiencia emocional positiva mediante frases breves, significativas y renovadas, utilizando inteligencia artificial y bases de datos escalables, en una interfaz simple y elegante.

---

## 🚀 Tecnologías

### 🧠 Inteligencia Artificial
- **Gemini Developer API (Google AI)**  
  Utilizado para generar frases motivacionales únicas cada día. La interacción se gestiona a través de Firebase Functions.

### ☁️ Backend / Almacenamiento
- **Firebase**  
  - En evaluación entre:
    - 🔄 **Firestore** (más escalable y flexible)
    - ⚡ **Realtime Database** (respuesta más rápida y sencilla)
  - Plan gratuito en consideración, con fallback planificado.

### 📱 App Móvil y Escritorio
- **Flutter** (base del desarrollo multiplataforma)
- Pruebas y comparativas con:
  - **Kotlin** (Android nativo)
  - **Swift** (iOS nativo)
  - **Flutter Desktop** (Windows)

### 💾 Base de datos local
- **Realm DB**  
  Utilizada como almacenamiento persistente cuando no hay conexión o cuando se superan los límites de Firebase. Permite que la app crezca y funcione sin IA o backend.

---

## 📦 Funcionalidades clave (fase inicial)

- [x] Lista base de frases en español
- [x] Generación diaria de nuevas frases usando IA
- [ ] Almacenamiento en Firestore/Realtime DB
- [ ] Guardado automático de nuevas frases en Realm para uso offline
- [ ] Interfaz adaptable para móvil y escritorio
- [ ] Monetización opcional no invasiva

---

## 💡 Visión de crecimiento

- Widgets de frases en pantalla
- Notificaciones diarias personalizadas
- Compartir frases por redes sociales
- Modo oscuro y temas personalizables
- Versión Premium sin publicidad
- Distribución en:
  - Google Play Store
  - Apple App Store
  - Huawei AppGallery
  - Microsoft Store (Windows)

---

## 📲 Instalación (próximamente)

> Instrucciones específicas para Flutter, Kotlin y Swift estarán disponibles en sus respectivas carpetas (`/flutter`, `/kotlin`, `/swift`) próximamente.

---

## 📁 Estructura del proyecto (tentativa)

```
runa/
├── flutter/
├── kotlin/
├── swift/
├── phrases/
│   └── base_phrases.json
├── firebase/
│   ├── functions/
│   └── firestore.rules
├── assets/
├── README.md
```

---

## 🧪 Estado del proyecto

🚧 En construcción.  
El desarrollo inicial comienza en Flutter, pero se acompañará de comparativas y pruebas en Kotlin y Swift para análisis de desempeño, UX y facilidad de despliegue multiplataforma.

---

## 📬 Contacto y actualizaciones

José Zarabanda  
[LinkedIn](https://www.linkedin.com/in/zarabandajose) | [YouTube](https://www.youtube.com/channel/UCsXEZiXNJ0r-inP-6_PKTzQ) | [TikTok](https://www.tiktok.com/@jozzer182tk)

---

## 📝 Licencia

MIT — libre para uso, modificación y aprendizaje.

---
