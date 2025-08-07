# 📋 GUÍA PASO A PASO: Subir AAB a Google Play Console

## 🎯 Archivo a Usar:
**`runa-v2-release-20250803_065614.aab`**
📍 Ubicación: `c:\Code\Multi\Runa\android\dist\`

---

## 📋 Pasos en Google Play Console:

### 1. **Crear nueva versión de prueba cerrada**
- Ve a tu aplicación en Google Play Console
- Navega a: **Prueba y lanza → Prueba cerrada**
- Haz clic en **"Crear nueva versión"**

### 2. **Subir el App Bundle**
- En "Paquetes de aplicación", haz clic en **"Subir"**
- Selecciona el archivo: `runa-v2-release-20250803_065614.aab`
- Espera a que se procese (puede tomar unos minutos)

### 3. **Configurar detalles de la versión**
```
Nombre de la versión: 1.0.1
```

### 4. **Notas de la versión (sugerida)**
```
Primera versión de Runa (v1.0.1)

Runa es una app de frases motivacionales generadas por inteligencia artificial. En esta versión podrás:

• Generar frases inspiradoras personalizadas
• Interfaz moderna y amigable
• Experiencia optimizada para Android
```

### 5. **Verificaciones Automáticas**
- ✅ **Version Code:** 2 (detectado automáticamente)
- ✅ **Application ID:** com.zarabandajose.runa
- ✅ **Símbolos de depuración:** Incluidos en el AAB
- ✅ **Firmado:** Verificado automáticamente

---

## ⚠️ Puntos Importantes:

### ✅ **Lo que DEBE coincidir:**
- **Nombre de la versión en Play Console:** `1.0.1`
- **Version Code en el AAB:** `2`
- **Application ID:** `com.zarabandajose.runa`

### ❌ **Errores a Evitar:**
- ❌ No uses "2" como nombre de versión (usa "1.0.1")
- ❌ No subas el AAB anterior con versionCode=1
- ❌ No cambies el Application ID

---

## 🔄 Si Encuentras Errores:

### Error: "Version Code ya existe"
**Solución:** El versionCode=2 es nuevo, no debería existir

### Error: "Problema con el paquete"
**Solución:** Usa el archivo correcto: `runa-v2-release-20250803_065614.aab`

### Error: "Símbolos de depuración"
**Solución:** Ya está resuelto en este AAB

---

## 📞 Información de Contacto en Play Console:

Cuando Play Console pida información adicional:

### **Información de la App:**
- **Nombre:** Runa
- **Descripción breve:** App de frases motivacionales con IA
- **Categoría:** Estilo de vida
- **Clasificación de contenido:** Para toda la familia

### **Política de Privacidad:**
- Debes tener una URL de política de privacidad
- Ejemplo: `https://tudominio.com/privacy-policy`

---

## ✅ Checklist Final:

- [ ] Archivo AAB correcto seleccionado
- [ ] Nombre de versión: 1.0.1
- [ ] Notas de versión completadas
- [ ] Información de la app configurada
- [ ] Política de privacidad añadida
- [ ] Capturas de pantalla subidas
- [ ] Icono de la app configurado

---

**🎉 ¡Con estos pasos tu app debería subirse sin errores!**
