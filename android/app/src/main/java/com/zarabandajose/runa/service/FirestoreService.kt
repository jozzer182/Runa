package com.zarabandajose.runa.service

import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.zarabandajose.runa.model.FraseData
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Servicio para interactuar con Firestore
 */
class FirestoreService {
    
    private val firestore = FirebaseFirestore.getInstance()
    private val frasesCollection = firestore.collection("frases")
    
    /**
     * Guarda una frase en Firestore
     */
    suspend fun saveFrase(frase: FraseData): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val fraseMap = mapOf(
                "id" to frase.id,
                "text" to frase.text,
                "createdAt" to frase.createdAt,
                "source" to frase.source
            )
            
            frasesCollection.document(frase.id.toString()).set(fraseMap).await()
            Result.success(Unit)
            
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    /**
     * Obtiene una frase aleatoria de Firestore
     */
    suspend fun getRandomFrase(): Result<FraseData> = withContext(Dispatchers.IO) {
        try {
            // Estrategia: obtener todas las frases y seleccionar una aleatoria
            // Para apps con muchas frases, se podría implementar una estrategia más eficiente
            val querySnapshot = frasesCollection
                .orderBy("createdAt", Query.Direction.DESCENDING)
                .limit(50) // Limitamos a las 50 más recientes para mejorar performance
                .get()
                .await()
            
            if (querySnapshot.isEmpty) {
                return@withContext Result.failure(Exception("No hay frases en Firestore"))
            }
            
            val documents = querySnapshot.documents
            val randomDocument = documents.random()
            
            val frase = FraseData(
                id = randomDocument.getLong("id") ?: 0,
                text = randomDocument.getString("text") ?: "",
                createdAt = randomDocument.getString("createdAt"),
                source = randomDocument.getString("source") ?: "firestore"
            )
            
            Result.success(frase)
            
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    /**
     * Obtiene todas las frases de Firestore (para sincronización)
     */
    suspend fun getAllFrases(): Result<List<FraseData>> = withContext(Dispatchers.IO) {
        try {
            val querySnapshot = frasesCollection
                .orderBy("createdAt", Query.Direction.DESCENDING)
                .get()
                .await()
            
            val frases = querySnapshot.documents.mapNotNull { document ->
                try {
                    FraseData(
                        id = document.getLong("id") ?: return@mapNotNull null,
                        text = document.getString("text") ?: return@mapNotNull null,
                        createdAt = document.getString("createdAt"),
                        source = document.getString("source") ?: "firestore"
                    )
                } catch (e: Exception) {
                    null
                }
            }
            
            Result.success(frases)
            
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
