import 'package:firebase_ai/firebase_ai.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  static GeminiService? _instance;
  static GeminiService get instance => _instance ??= GeminiService._();
  
  GeminiService._();
  
  // Firebase AI Logic service and model
  FirebaseAI? _firebaseAI;
  GenerativeModel? _model;
  bool _isInitialized = false;
  
  // Configuración del modelo
  static const String _modelName = 'gemini-2.0-flash';
  
  Future<void> initialize() async {
    try {
      debugPrint('🔄 Initializing Firebase AI Logic...');
      
      // Initialize Firebase AI Logic with Google AI backend (Gemini Developer API)
      _firebaseAI = FirebaseAI.googleAI();
      
      // Create the generative model instance
      _model = _firebaseAI!.generativeModel(model: _modelName);
      
      _isInitialized = true;
      
      debugPrint('✅ Firebase AI Logic (Gemini) initialized successfully');
      debugPrint('📱 Model: $_modelName');
      debugPrint('🔗 Backend: Gemini Developer API');
      
    } catch (e) {
      debugPrint('❌ Error initializing Firebase AI Logic: $e');
      _isInitialized = false;
      rethrow;
    }
  }
  
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }
  
  // Generar nueva frase motivacional usando Gemini real
  Future<String?> generateMotivationalPhrase() async {
    try {
      if (!_isInitialized) {
        debugPrint('⚠️ Gemini service not initialized properly');
        return null;
      }
      
      if (!await hasInternetConnection()) {
        debugPrint('⚠️ No internet connection available');
        return null;
      }
      
      // Verificar si el modelo está disponible
      if (_model == null) {
        debugPrint('⚠️ Modelo de Firebase AI Logic no configurado aún. Usando fallback...');
        return _getFallbackPhrase();
      }
      
      // Prompt optimizado para generar frases motivacionales
      const prompt = '''
Genera una frase motivacional corta en español que inspire y motive a las personas a seguir adelante en su vida diaria.

Requisitos:
- Máximo 80 caracteres
- Mensaje positivo y esperanzador
- En español
- Sin comillas
- Enfocada en: superación personal, perseverancia, confianza, o logro de metas
- Evita clichés muy comunes

Responde solo con la frase, sin explicaciones adicionales.
''';
      
      debugPrint('🤖 Generating phrase with Gemini...');
      
      // Enviar request a Gemini usando la API correcta
      final response = await _model!.generateContent([
        Content.text(prompt),
      ]);
      
      if (response.text != null && response.text!.isNotEmpty) {
        // Limpiar y procesar la respuesta
        String cleanedText = response.text!.trim();
        
        // Remover comillas si las hay
        cleanedText = cleanedText.replaceAll('"', '');
        cleanedText = cleanedText.replaceAll("'", '');
        cleanedText = cleanedText.replaceAll('«', '');
        cleanedText = cleanedText.replaceAll('»', '');
        
        // Capitalizar primera letra si es necesario
        if (cleanedText.isNotEmpty) {
          cleanedText = cleanedText[0].toUpperCase() + cleanedText.substring(1);
        }
        
        // Verificar longitud y truncar si es necesario
        if (cleanedText.length > 120) {
          cleanedText = cleanedText.substring(0, 117) + '...';
        }
        
        debugPrint('✅ Generated phrase (real): "$cleanedText"');
        return cleanedText;
      } else {
        debugPrint('⚠️ Empty response from Gemini');
        return null;
      }
      
    } catch (e) {
      debugPrint('❌ Error generating phrase with Gemini: $e');
      
      // Detectar tipos de error específicos
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('quota') || 
          errorString.contains('limit') || 
          errorString.contains('resource_exhausted') ||
          errorString.contains('rate limit')) {
        debugPrint('🚫 Gemini quota/rate limit exceeded');
      } else if (errorString.contains('api key') || 
                 errorString.contains('authentication') ||
                 errorString.contains('permission')) {
        debugPrint('🔑 Authentication/API key error');
      } else if (errorString.contains('network') || 
                 errorString.contains('connection')) {
        debugPrint('🌐 Network connectivity error');
      }
      
      return null;
    }
  }
  
  // Frases de fallback de alta calidad
  String _getFallbackPhrase() {
    final fallbackPhrases = [
      'Tu potencial no conoce límites, solo tú los defines.',
      'Cada obstáculo es una oportunidad disfrazada.',
      'El éxito comienza con un solo paso decidido.',
      'Tus sueños son el mapa hacia tu grandeza.',
      'La perseverancia convierte lo imposible en inevitable.',
      'Eres el arquitecto de tu propio destino.',
      'Cada día es una nueva oportunidad para brillar.',
      'La confianza en ti mismo es tu superpoder.',
      'Los desafíos de hoy son las victorias de mañana.',
      'Tu actitud determina tu altitud en la vida.',
    ];
    
    final randomIndex = DateTime.now().millisecondsSinceEpoch % fallbackPhrases.length;
    final selectedPhrase = fallbackPhrases[randomIndex];
    
    debugPrint('✅ Generated phrase (fallback): "$selectedPhrase"');
    return selectedPhrase;
  }
  
  // Verificar si Gemini está disponible
  Future<bool> isGeminiAvailable() async {
    try {
      if (!_isInitialized) {
        return false;
      }
      
      if (!await hasInternetConnection()) {
        return false;
      }
      
      // Si no hay modelo real, reportar como "disponible" en modo fallback
      if (_model == null) {
        debugPrint('✅ Gemini available (fallback mode)');
        return true;
      }
      
      // Hacer una consulta simple para verificar que funciona
      debugPrint('🔍 Testing Gemini availability...');
      
      final response = await _model!.generateContent([
        Content.text('Hola')
      ]);
      
      final isAvailable = response.text != null && response.text!.isNotEmpty;
      debugPrint(isAvailable ? '✅ Gemini is available (real)' : '❌ Gemini test failed');
      
      return isAvailable;
    } catch (e) {
      debugPrint('❌ Gemini availability check failed: $e');
      return false;
    }
  }
  
  // Información sobre el estado del servicio
  Map<String, dynamic> getServiceInfo() {
    return {
      'isInitialized': _isInitialized,
      'modelName': _modelName,
      'hasModel': _model != null,
      'backend': _model != null ? 'Firebase AI Logic (Real)' : 'Firebase AI Logic (Fallback)',
      'mode': _model != null ? 'production' : 'fallback',
    };
  }
}
