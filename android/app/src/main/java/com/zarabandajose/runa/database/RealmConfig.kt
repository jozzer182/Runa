package com.zarabandajose.runa.database

import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import com.zarabandajose.runa.model.Frase

/**
 * Configuración y manejo de la base de datos Realm
 */
object RealmConfig {
    
    private var _realm: Realm? = null
    
    val realm: Realm
        get() = _realm ?: throw IllegalStateException("Realm no ha sido inicializado")
    
    /**
     * Inicializa la configuración de Realm
     */
    fun initialize() {
        val config = RealmConfiguration.Builder(
            schema = setOf(Frase::class)
        )
        .name("runa.realm")
        .schemaVersion(1)
        .build()
        
        _realm = Realm.open(config)
    }
    
    /**
     * Cierra la conexión a Realm
     */
    fun close() {
        _realm?.close()
        _realm = null
    }
}
