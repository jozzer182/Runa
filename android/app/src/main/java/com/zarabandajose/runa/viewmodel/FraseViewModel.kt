package com.zarabandajose.runa.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import com.zarabandajose.runa.database.FraseDao
import com.zarabandajose.runa.database.RealmConfig
import com.zarabandajose.runa.model.FraseData
import com.zarabandajose.runa.repository.FraseRepository
import com.zarabandajose.runa.service.FirebaseAIService
import com.zarabandajose.runa.service.FirestoreService
import kotlinx.coroutines.launch

/**
 * Estados posibles de la UI
 */
sealed class FraseUiState {
    object Loading : FraseUiState()
    data class Success(val frase: FraseData) : FraseUiState()
    data class Error(val message: String) : FraseUiState()
}

/**
 * ViewModel principal para manejar la lógica de la UI
 */
class FraseViewModel(application: Application) : AndroidViewModel(application) {
    
    // Dependencias
    private val repository: FraseRepository
    
    // Estados de la UI
    private val _uiState = mutableStateOf<FraseUiState>(FraseUiState.Loading)
    val uiState: State<FraseUiState> = _uiState
    
    private val _isRefreshing = mutableStateOf(false)
    val isRefreshing: State<Boolean> = _isRefreshing
    
    init {
        // Inicializar dependencias
        val fraseDao = FraseDao()
        val aiService = FirebaseAIService()
        val firestoreService = FirestoreService()
        
        repository = FraseRepository(
            context = application,
            fraseDao = fraseDao,
            aiService = aiService,
            firestoreService = firestoreService
        )
        
        // Inicializar la app
        initializeApp()
    }
    
    /**
     * Inicializa la aplicación
     */
    private fun initializeApp() {
        viewModelScope.launch {
            try {
                _uiState.value = FraseUiState.Loading
                
                // Inicializar base de datos local
                repository.initializeLocalDatabase().fold(
                    onSuccess = {
                        // Cargar primera frase
                        loadFrase()
                    },
                    onFailure = { exception ->
                        _uiState.value = FraseUiState.Error(
                            "Error inicializando la app: ${exception.message}"
                        )
                    }
                )
                
            } catch (e: Exception) {
                _uiState.value = FraseUiState.Error(
                    "Error inesperado: ${e.message}"
                )
            }
        }
    }
    
    /**
     * Carga una nueva frase siguiendo el flujo definido
     */
    fun loadFrase() {
        viewModelScope.launch {
            try {
                _uiState.value = FraseUiState.Loading
                
                repository.getFrase().fold(
                    onSuccess = { frase ->
                        _uiState.value = FraseUiState.Success(frase)
                    },
                    onFailure = { exception ->
                        _uiState.value = FraseUiState.Error(
                            "Error cargando frase: ${exception.message}"
                        )
                    }
                )
                
            } catch (e: Exception) {
                _uiState.value = FraseUiState.Error(
                    "Error inesperado: ${e.message}"
                )
            }
        }
    }
    
    /**
     * Recarga manual (llamada desde el botón de refresh)
     */
    fun refreshFrase() {
        viewModelScope.launch {
            try {
                _isRefreshing.value = true
                
                repository.forceReload().fold(
                    onSuccess = { frase ->
                        _uiState.value = FraseUiState.Success(frase)
                    },
                    onFailure = { exception ->
                        _uiState.value = FraseUiState.Error(
                            "Error actualizando frase: ${exception.message}"
                        )
                    }
                )
                
            } catch (e: Exception) {
                _uiState.value = FraseUiState.Error(
                    "Error inesperado: ${e.message}"
                )
            } finally {
                _isRefreshing.value = false
            }
        }
    }
    
    /**
     * Limpia recursos cuando el ViewModel es destruido
     */
    override fun onCleared() {
        super.onCleared()
        try {
            RealmConfig.close()
        } catch (e: Exception) {
            // Log pero no crashear
        }
    }
}
