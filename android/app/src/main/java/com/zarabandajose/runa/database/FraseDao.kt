package com.zarabandajose.runa.database

import io.realm.kotlin.ext.query
import com.zarabandajose.runa.model.Frase
import com.zarabandajose.runa.model.FraseData
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/**
 * Data Access Object para las frases
 * Maneja todas las operaciones CRUD con Realm
 */
class FraseDao {
    
    private val realm = RealmConfig.realm
    
    /**
     * Obtiene todas las frases como Flow para reactividad
     */
    fun getAllFrases(): Flow<List<FraseData>> {
        return realm.query<Frase>()
            .asFlow()
            .map { results ->
                results.list.map { frase ->
                    FraseData.fromRealm(frase)
                }
            }
    }
    
    /**
     * Obtiene una frase aleatoria
     */
    suspend fun getRandomFrase(): FraseData? {
        val frases = realm.query<Frase>().find()
        return if (frases.isNotEmpty()) {
            val randomFrase = frases.random()
            FraseData.fromRealm(randomFrase)
        } else {
            null
        }
    }
    
    /**
     * Inserta una nueva frase
     */
    suspend fun insertFrase(fraseData: FraseData) {
        realm.write {
            val frase = Frase().apply {
                id = fraseData.id
                text = fraseData.text
                createdAt = fraseData.createdAt
                source = fraseData.source
            }
            copyToRealm(frase)
        }
    }
    
    /**
     * Inserta múltiples frases (para carga inicial)
     */
    suspend fun insertFrases(frases: List<FraseData>) {
        realm.write {
            frases.forEach { fraseData ->
                val frase = Frase().apply {
                    id = fraseData.id
                    text = fraseData.text
                    createdAt = fraseData.createdAt
                    source = fraseData.source
                }
                copyToRealm(frase)
            }
        }
    }
    
    /**
     * Verifica si hay frases en la base de datos
     */
    suspend fun hasAnyFrases(): Boolean {
        return realm.query<Frase>().count().find() > 0
    }
    
    /**
     * Obtiene la frase con el ID más alto (para generar nuevos IDs)
     */
    suspend fun getMaxId(): Long {
        val maxFrase = realm.query<Frase>()
            .sort("id", io.realm.kotlin.query.Sort.DESCENDING)
            .first()
            .find()
        return maxFrase?.id ?: 0
    }
    
    /**
     * Elimina todas las frases (útil para testing)
     */
    suspend fun deleteAllFrases() {
        realm.write {
            val frases = query<Frase>().find()
            delete(frases)
        }
    }
}
