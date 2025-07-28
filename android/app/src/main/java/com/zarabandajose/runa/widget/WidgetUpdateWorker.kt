package com.zarabandajose.runa.widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.util.Log
import android.widget.RemoteViews
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.zarabandajose.runa.R
import com.zarabandajose.runa.database.FraseDao
import com.zarabandajose.runa.database.RealmConfig
import com.zarabandajose.runa.repository.FraseRepository
import com.zarabandajose.runa.service.FirebaseAIService
import com.zarabandajose.runa.service.FirestoreService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Worker que se encarga de actualizar el contenido del widget
 * usando el mismo sistema de frases que la app principal
 */
class WidgetUpdateWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    companion object {
        private const val TAG = "WidgetUpdateWorker"
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        try {
            // Inicializar servicios (similar a MainActivity)
            RealmConfig.initialize()
            
            val fraseDao = FraseDao()
            val aiService = FirebaseAIService()
            val firestoreService = FirestoreService()
            val repository = FraseRepository(
                context = applicationContext,
                fraseDao = fraseDao,
                aiService = aiService,
                firestoreService = firestoreService
            )
            
            // Inicializar base de datos si es necesario
            repository.initializeLocalDatabase()
            
            // Obtener frase siguiendo la misma lógica que la app
            val fraseResult = repository.getFrase()
            
            val fraseText = fraseResult.fold(
                onSuccess = { fraseData ->
                    fraseData.text
                },
                onFailure = { exception ->
                    Log.e(TAG, "Error obteniendo frase", exception)
                    "✨ La inspiración llega cuando menos la esperas"
                }
            )
            
            // Actualizar todos los widgets
            updateAllWidgets(fraseText)
            
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "Error en WidgetUpdateWorker", e)
            // En caso de error, mostrar frase por defecto
            updateAllWidgets("🌟 Mantén la esperanza viva")
            Result.retry()
        }
    }

    private suspend fun updateAllWidgets(fraseText: String) = withContext(Dispatchers.Main) {
        val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
        val componentName = ComponentName(applicationContext, RunaWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
        
        // Detectar tema oscuro
        val isDarkTheme = isDarkModeEnabled(applicationContext)
        
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(applicationContext.packageName, R.layout.widget_layout)
            
            // Actualizar el texto de la frase
            views.setTextViewText(R.id.widget_phrase_text, fraseText)
            
            // Ajustar colores según el tema
            if (isDarkTheme) {
                views.setTextColor(R.id.widget_phrase_text, 0xFFFFFFFF.toInt()) // Blanco puro
                views.setTextColor(R.id.widget_refresh_button, 0xFF888888.toInt()) // Gris claro
            } else {
                views.setTextColor(R.id.widget_phrase_text, 0xFFFFFFFF.toInt()) // Blanco
                views.setTextColor(R.id.widget_refresh_button, 0xFFE1BEE7.toInt()) // Violeta claro
            }
            
            // Mantener los listeners (se configuran en el provider)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        Log.d(TAG, "Widgets actualizados con: $fraseText (tema oscuro: $isDarkTheme)")
    }

    private fun isDarkModeEnabled(context: Context): Boolean {
        return when (context.resources.configuration.uiMode and 
                     android.content.res.Configuration.UI_MODE_NIGHT_MASK) {
            android.content.res.Configuration.UI_MODE_NIGHT_YES -> true
            else -> false
        }
    }
}
