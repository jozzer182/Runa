package com.zarabandajose.runa.model

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey

/**
 * Modelo de datos para las frases motivacionales
 * Implementa RealmObject para persistencia local
 */
class Frase : RealmObject {
    @PrimaryKey
    var id: Long = 0
    var text: String = ""
    var createdAt: String? = null
    var source: String = "base" // "base", "ai", "firestore"
    
    constructor()
    
    constructor(id: Long, text: String, createdAt: String?, source: String) {
        this.id = id
        this.text = text
        this.createdAt = createdAt
        this.source = source
    }
}

/**
 * Data class para manejo de frases en la UI (no persiste en Realm)
 */
data class FraseData(
    val id: Long,
    val text: String,
    val createdAt: String?,
    val source: String
) {
    companion object {
        fun fromRealm(frase: Frase): FraseData {
            return FraseData(
                id = frase.id,
                text = frase.text,
                createdAt = frase.createdAt,
                source = frase.source
            )
        }
    }
}

/**
 * Data class para el JSON de frases base
 */
data class BasePhrases(
    val phrases: List<FraseData>
)
