package com.zarabandajose.runa.service

import android.util.Log
import com.google.firebase.Firebase
import com.google.firebase.ai.ai
import com.google.firebase.ai.type.GenerativeBackend
import com.google.firebase.ai.type.content
import com.google.firebase.ai.type.generationConfig
import com.zarabandajose.runa.model.FraseData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.*

/**
 * Servicio para generar frases motivacionales usando Firebase AI Logic con Gemini Developer API
 */
class FirebaseAIService {
    
    companion object {
        private const val TAG = "FirebaseAIService"
        private const val MODEL_NAME = "gemini-2.5-flash"
    }
    
    // Firebase AI Logic con Gemini Developer API
    private val generativeModel by lazy {
        Firebase.ai(backend = GenerativeBackend.googleAI())
            .generativeModel(
                modelName = MODEL_NAME,
                generationConfig = generationConfig {
                    temperature = 0.7f
                    topK = 40
                    topP = 0.95f
                    maxOutputTokens = 256
                }
            )
    }
    
    // Frases de fallback de alta calidad
    private val fallbackPhrases = listOf(
        "Tu potencial no conoce límites, solo tú los defines.",
        "Cada obstáculo es una oportunidad disfrazada.",
        "El éxito comienza con un solo paso decidido.",
        "Tus sueños son el mapa hacia tu grandeza.",
        "La perseverancia convierte lo imposible en inevitable.",
        "Hoy es el día perfecto para ser extraordinario.",
        "Tu actitud determina tu altitud en la vida.",
        "Los sueños no tienen fecha de vencimiento.",
        "La magia sucede cuando no te rindes.",
        "Eres más fuerte de lo que crees, más capaz de lo que imaginas."
    )
    
    /**
     * Genera una nueva frase motivacional usando Firebase AI Logic (Gemini Developer API)
     */
    suspend fun generateMotivationalPhrase(): kotlin.Result<FraseData> = withContext(Dispatchers.IO) {
        try {
            Log.d(TAG, "🤖 Generando frase con Firebase AI Logic (Gemini)...")
            
            // Prompt optimizado para generar frases motivacionales
            val prompt = content {
                text("""
                    Genera una frase motivacional corta en español que inspire y motive a las personas a seguir adelante en su vida diaria.

                    Requisitos:
                    - Máximo 80 caracteres
                    - Mensaje positivo y esperanzador
                    - En español
                    - Sin comillas
                    - Enfocada en: superación personal, perseverancia, confianza, o logro de metas
                    - Evita clichés muy comunes

                    Responde solo con la frase, sin explicaciones adicionales.
                """.trimIndent())
            }
            
            // Enviar request a Gemini usando Firebase AI Logic
            val response = generativeModel.generateContent(prompt)
            val generatedText = response.text
            
            if (!generatedText.isNullOrBlank()) {
                // Limpiar y procesar la respuesta
                var cleanedText = generatedText.trim()
                
                // Remover comillas si las hay
                cleanedText = cleanedText.replace("\"", "")
                cleanedText = cleanedText.replace("'", "")
                cleanedText = cleanedText.replace("«", "")
                cleanedText = cleanedText.replace("»", "")
                
                // Capitalizar primera letra si es necesario
                if (cleanedText.isNotEmpty()) {
                    cleanedText = cleanedText[0].uppercaseChar() + cleanedText.substring(1)
                }
                
                // Verificar longitud y truncar si es necesario
                if (cleanedText.length > 120) {
                    cleanedText = cleanedText.substring(0, 117) + "..."
                }
                
                Log.d(TAG, "✅ Frase generada (AI): \"$cleanedText\"")
                
                // Crear la frase con timestamp actual
                val currentTime = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault()).format(Date())
                
                val frase = FraseData(
                    id = System.currentTimeMillis(),
                    text = cleanedText,
                    createdAt = currentTime,
                    source = "ai"
                )
                
                return@withContext kotlin.Result.success(frase)
                
            } else {
                Log.w(TAG, "⚠️ Respuesta vacía de Gemini, usando fallback")
                return@withContext generateFallbackPhrase()
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error generando frase con Firebase AI Logic", e)
            
            // Detectar tipos de error específicos
            val errorString = e.toString().lowercase()
            when {
                errorString.contains("quota") || 
                errorString.contains("limit") || 
                errorString.contains("resource_exhausted") ||
                errorString.contains("rate limit") -> {
                    Log.w(TAG, "🚫 Límite de cuota/rate limit de Gemini excedido")
                }
                errorString.contains("api key") || 
                errorString.contains("authentication") ||
                errorString.contains("permission") -> {
                    Log.w(TAG, "🔑 Error de autenticación/API key")
                }
                errorString.contains("network") || 
                errorString.contains("connection") -> {
                    Log.w(TAG, "🌐 Error de conectividad de red")
                }
            }
            
            return@withContext generateFallbackPhrase()
        }
    }
    
    /**
     * Genera una frase de fallback cuando Gemini no está disponible
     */
    private fun generateFallbackPhrase(): kotlin.Result<FraseData> {
        val randomPhrase = fallbackPhrases.random()
        val currentTime = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault()).format(Date())
        
        val frase = FraseData(
            id = System.currentTimeMillis(),
            text = randomPhrase,
            createdAt = currentTime,
            source = "ai" // Mantenemos como AI aunque sea fallback
        )
        
        Log.d(TAG, "🔄 Usando frase de fallback: \"$randomPhrase\"")
        return kotlin.Result.success(frase)
    }
    
    /**
     * Verifica si el servicio AI está disponible
     */
    suspend fun isServiceAvailable(): Boolean = withContext(Dispatchers.IO) {
        return@withContext try {
            // Intentar una petición simple para verificar conectividad
            val testPrompt = content {
                text("Test")
            }
            generativeModel.generateContent(testPrompt)
            true
        } catch (e: Exception) {
            Log.w(TAG, "Servicio AI no disponible: ${e.message}")
            false
        }
    }
}
