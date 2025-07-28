package com.zarabandajose.runa.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import androidx.work.*
import com.zarabandajose.runa.R
import kotlinx.coroutines.*
import java.util.concurrent.TimeUnit

/**
 * Widget Provider para mostrar frases inspiradoras de Runa
 */
class RunaWidgetProvider : AppWidgetProvider() {
    
    companion object {
        const val ACTION_REFRESH = "com.zarabandajose.runa.widget.REFRESH"
        const val TAG = "RunaWidgetProvider"
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // Actualizar todos los widgets
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        
        // Programar actualizaciones automáticas cada 30 minutos
        schedulePeriodicUpdates(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        when (intent.action) {
            ACTION_REFRESH -> {
                // Actualizar todos los widgets cuando se presiona refresh
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, RunaWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
        }
    }

    override fun onEnabled(context: Context) {
        // Llamado cuando se agrega el primer widget
        schedulePeriodicUpdates(context)
    }

    override fun onDisabled(context: Context) {
        // Llamado cuando se elimina el último widget
        cancelPeriodicUpdates(context)
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        
        // Configurar el botón de refresh
        val refreshIntent = Intent(context, RunaWidgetProvider::class.java).apply {
            action = ACTION_REFRESH
        }
        val refreshPendingIntent = PendingIntent.getBroadcast(
            context, 
            0, 
            refreshIntent, 
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )
        views.setOnClickPendingIntent(R.id.widget_refresh_button, refreshPendingIntent)
        
        // Configurar click en el widget para abrir la app
        val appIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val appPendingIntent = PendingIntent.getActivity(
            context, 
            0, 
            appIntent, 
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )
        views.setOnClickPendingIntent(R.id.widget_phrase_text, appPendingIntent)
        
        // Iniciar worker para cargar frase
        val workRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>()
            .setInputData(workDataOf("appWidgetId" to appWidgetId))
            .build()
        WorkManager.getInstance(context).enqueue(workRequest)
        
        // Mostrar estado de carga inicialmente
        views.setTextViewText(R.id.widget_phrase_text, "🌟 Cargando frase inspiradora...")
        
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun schedulePeriodicUpdates(context: Context) {
        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(30, TimeUnit.MINUTES)
            .setConstraints(
                Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .build()
            )
            .build()
        
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            "widget_periodic_update",
            ExistingPeriodicWorkPolicy.REPLACE,
            workRequest
        )
    }

    private fun cancelPeriodicUpdates(context: Context) {
        WorkManager.getInstance(context).cancelUniqueWork("widget_periodic_update")
    }
}
