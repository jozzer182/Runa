package com.zarabandajose.runa

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.google.firebase.FirebaseApp
import com.zarabandajose.runa.database.RealmConfig
import com.zarabandajose.runa.model.FraseData
import com.zarabandajose.runa.ui.theme.RunaTheme
import com.zarabandajose.runa.viewmodel.FraseUiState
import com.zarabandajose.runa.viewmodel.FraseViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Inicializar Firebase
        FirebaseApp.initializeApp(this)
        
        // Inicializar Realm
        RealmConfig.initialize()
        
        enableEdgeToEdge()
        setContent {
            RunaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    RunaApp()
                }
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            RealmConfig.close()
        } catch (e: Exception) {
            // Silent fail
        }
    }
}

@Composable
fun RunaApp(
    viewModel: FraseViewModel = viewModel()
) {
    val uiState by viewModel.uiState
    val isRefreshing by viewModel.isRefreshing
    val context = LocalContext.current
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        // Header
        Text(
            text = "Runa ✨",
            fontSize = 32.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
            textAlign = TextAlign.Center
        )
        
        Text(
            text = "Tu dosis diaria de motivación",
            fontSize = 16.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )
        
        // Content based on state
        when (val currentState = uiState) {
            is FraseUiState.Loading -> {
                LoadingContent()
            }
            is FraseUiState.Success -> {
                FraseContent(
                    frase = currentState.frase,
                    isRefreshing = isRefreshing,
                    onRefresh = { viewModel.refreshFrase() },
                    onCopy = { copyToClipboard(context, currentState.frase.text) }
                )
            }
            is FraseUiState.Error -> {
                ErrorContent(
                    message = currentState.message,
                    onRetry = { viewModel.loadFrase() }
                )
            }
        }
    }
}

@Composable
fun LoadingContent() {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.padding(32.dp)
    ) {
        CircularProgressIndicator(
            modifier = Modifier.size(48.dp),
            color = MaterialTheme.colorScheme.primary
        )
        Spacer(modifier = Modifier.height(16.dp))
        Text(
            text = "Preparando tu inspiración...",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
fun FraseContent(
    frase: FraseData,
    isRefreshing: Boolean,
    onRefresh: () -> Unit,
    onCopy: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 16.dp),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
    ) {
        Column(
            modifier = Modifier.padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Phrase text
            Text(
                text = frase.text,
                fontSize = 20.sp,
                fontWeight = FontWeight.Medium,
                textAlign = TextAlign.Center,
                lineHeight = 28.sp,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.padding(bottom = 16.dp)
            )
            
            // Source indicator
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.padding(bottom = 24.dp)
            ) {
                val sourceText = when (frase.source) {
                    "ai" -> "✨ Generada con IA"
                    "firestore" -> "☁️ Desde la nube"
                    "base" -> "📚 Frase base"
                    "fallback" -> "🔧 Mantenimiento"
                    else -> "💫 Runa"
                }
                
                Text(
                    text = sourceText,
                    fontSize = 12.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            
            // Action buttons
            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Copy button
                OutlinedButton(
                    onClick = onCopy,
                    modifier = Modifier.weight(1f)
                ) {
                    Text("📋 Copiar")
                }
                
                // Refresh button
                Button(
                    onClick = onRefresh,
                    enabled = !isRefreshing,
                    modifier = Modifier.weight(1f)
                ) {
                    if (isRefreshing) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(18.dp),
                            strokeWidth = 2.dp,
                            color = MaterialTheme.colorScheme.onPrimary
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Cargando...")
                    } else {
                        Text("🔄 Nueva")
                    }
                }
            }
        }
    }
}

@Composable
fun ErrorContent(
    message: String,
    onRetry: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.errorContainer
        )
    ) {
        Column(
            modifier = Modifier.padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "😔 Oops!",
                fontSize = 24.sp,
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Text(
                text = message,
                textAlign = TextAlign.Center,
                color = MaterialTheme.colorScheme.onErrorContainer,
                modifier = Modifier.padding(bottom = 16.dp)
            )
            
            Button(
                onClick = onRetry,
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.error
                )
            ) {
                Text("Reintentar")
            }
        }
    }
}

// Utility function to copy text to clipboard
private fun copyToClipboard(context: Context, text: String) {
    val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    val clip = ClipData.newPlainText("Frase motivacional", text)
    clipboard.setPrimaryClip(clip)
    
    Toast.makeText(context, "Frase copiada al portapapeles ✨", Toast.LENGTH_SHORT).show()
}

@Preview(showBackground = true)
@Composable
fun RunaAppPreview() {
    RunaTheme {
        Surface {
            FraseContent(
                frase = FraseData(
                    id = 1,
                    text = "Hoy es un buen día para comenzar de nuevo.",
                    createdAt = null,
                    source = "base"
                ),
                isRefreshing = false,
                onRefresh = {},
                onCopy = {}
            )
        }
    }
}