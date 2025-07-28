package com.zarabandajose.runa.utils

import android.content.Context
import com.google.gson.Gson
import com.zarabandajose.runa.model.BasePhrases
import com.zarabandajose.runa.model.FraseData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.IOException

/**
 * Utilidad para cargar las frases base desde el archivo JSON
 */
object JsonLoader {
    
    /**
     * Carga las frases base desde assets/base_phrases.json
     */
    suspend fun loadBasePhrases(context: Context): Result<List<FraseData>> = withContext(Dispatchers.IO) {
        try {
            val json = context.assets.open("base_phrases.json").use { inputStream ->
                inputStream.bufferedReader().use { it.readText() }
            }
            
            val gson = Gson()
            val basePhrases = gson.fromJson(json, BasePhrases::class.java)
            
            if (basePhrases.phrases.isEmpty()) {
                return@withContext Result.failure(Exception("No se encontraron frases en el archivo JSON"))
            }
            
            Result.success(basePhrases.phrases)
            
        } catch (e: IOException) {
            Result.failure(Exception("Error al leer el archivo JSON: ${e.message}"))
        } catch (e: Exception) {
            Result.failure(Exception("Error al parsear el JSON: ${e.message}"))
        }
    }
}
