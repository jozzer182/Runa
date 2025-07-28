package com.zarabandajose.runa.repository

import android.content.Context
import android.util.Log
import com.zarabandajose.runa.database.FraseDao
import com.zarabandajose.runa.model.FraseData
import com.zarabandajose.runa.service.FirebaseAIService
import com.zarabandajose.runa.service.FirestoreService
import com.zarabandajose.runa.utils.JsonLoader
import kotlinx.coroutines.flow.Flow

/**
 * Repositorio principal que maneja el flujo de datos según los requisitos:
 * 1. Intenta generar frase con AI
 * 2. Si falla, busca en Firestore
 * 3. Si falla, busca en Realm local
 * 4. Si todo falla, muestra mensaje de mantenimiento
 */
class FraseRepository(
    private val context: Context,
    private val fraseDao: FraseDao,
    private val aiService: FirebaseAIService,
    private val firestoreService: FirestoreService
) {
    
    companion object {
        private const val TAG = "FraseRepository"
    }
    
    /**
     * Inicializa la base de datos local si está vacía
     */
    suspend fun initializeLocalDatabase(): Result<Unit> {
        return try {
            if (!fraseDao.hasAnyFrases()) {
                Log.d(TAG, "Base de datos vacía, cargando frases base...")
                
                val baseFrasesResult = JsonLoader.loadBasePhrases(context)
                baseFrasesResult.fold(
                    onSuccess = { frases ->
                        fraseDao.insertFrases(frases)
                        Log.d(TAG, "Se cargaron ${frases.size} frases base")
                        Result.success(Unit)
                    },
                    onFailure = { exception ->
                        Log.e(TAG, "Error cargando frases base", exception)
                        Result.failure(exception)
                    }
                )
            } else {
                Log.d(TAG, "Base de datos ya inicializada")
                Result.success(Unit)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error inicializando base de datos", e)
            Result.failure(e)
        }
    }
    
    /**
     * Obtiene una frase siguiendo el flujo definido en los requisitos
     */
    suspend fun getFrase(): Result<FraseData> {
        Log.d(TAG, "Iniciando flujo para obtener frase...")
        
        // 1. Intentar generar frase con AI
        Log.d(TAG, "Paso 1: Intentando generar frase con AI...")
        val aiResult = aiService.generateMotivationalPhrase()
        
        aiResult.fold(
            onSuccess = { frase ->
                Log.d(TAG, "✅ Frase generada con AI: ${frase.text}")
                
                // Asignar nuevo ID secuencial
                val newId = fraseDao.getMaxId() + 1
                val fraseWithNewId = frase.copy(id = newId)
                
                // Guardar en Realm
                fraseDao.insertFrase(fraseWithNewId)
                
                // Intentar guardar en Firestore (sin bloquear si falla)
                firestoreService.saveFrase(fraseWithNewId).fold(
                    onSuccess = { Log.d(TAG, "Frase guardada en Firestore") },
                    onFailure = { Log.w(TAG, "No se pudo guardar en Firestore, pero continuamos") }
                )
                
                return Result.success(fraseWithNewId)
            },
            onFailure = { exception ->
                Log.w(TAG, "❌ Fallo AI: ${exception.message}")
            }
        )
        
        // 2. Intentar obtener de Firestore
        Log.d(TAG, "Paso 2: Intentando obtener frase de Firestore...")
        val firestoreResult = firestoreService.getRandomFrase()
        
        firestoreResult.fold(
            onSuccess = { frase ->
                Log.d(TAG, "✅ Frase obtenida de Firestore: ${frase.text}")
                return Result.success(frase)
            },
            onFailure = { exception ->
                Log.w(TAG, "❌ Fallo Firestore: ${exception.message}")
            }
        )
        
        // 3. Obtener de Realm local
        Log.d(TAG, "Paso 3: Obteniendo frase de base local...")
        val localFrase = fraseDao.getRandomFrase()
        
        if (localFrase != null) {
            Log.d(TAG, "✅ Frase obtenida localmente: ${localFrase.text}")
            return Result.success(localFrase)
        }
        
        // 4. Todo falló - mensaje de mantenimiento
        Log.e(TAG, "❌ Todos los métodos fallaron")
        val fallbackFrase = FraseData(
            id = -1,
            text = "Estamos actualizando las frases motivacionales. Vuelve en unos días para más inspiración. 💫",
            createdAt = null,
            source = "fallback"
        )
        
        return Result.success(fallbackFrase)
    }
    
    /**
     * Fuerza la recarga manual (llamado desde UI)
     */
    suspend fun forceReload(): Result<FraseData> {
        Log.d(TAG, "🔄 Recarga manual solicitada")
        return getFrase()
    }
    
    /**
     * Obtiene todas las frases locales como Flow (para futuras funcionalidades)
     */
    fun getAllLocalFrases(): Flow<List<FraseData>> {
        return fraseDao.getAllFrases()
    }
    
    /**
     * Sincroniza con Firestore (para futuras funcionalidades)
     */
    suspend fun syncWithFirestore(): Result<Int> {
        return try {
            val firestoreResult = firestoreService.getAllFrases()
            firestoreResult.fold(
                onSuccess = { frases ->
                    // Aquí se podría implementar lógica de sincronización más sofisticada
                    Log.d(TAG, "Sincronización disponible: ${frases.size} frases en Firestore")
                    Result.success(frases.size)
                },
                onFailure = { exception ->
                    Log.e(TAG, "Error en sincronización", exception)
                    Result.failure(exception)
                }
            )
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
