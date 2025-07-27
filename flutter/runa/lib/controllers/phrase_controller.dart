import 'package:flutter/material.dart';
import '../models/phrase.dart';
import '../services/realm_service.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';

class PhraseController extends ChangeNotifier {
  static PhraseController? _instance;
  static PhraseController get instance => _instance ??= PhraseController._();
  
  PhraseController._();
  
  // Estado actual
  Phrase? _currentPhrase;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  
  // Getters
  Phrase? get currentPhrase => _currentPhrase;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  
  // Servicios
  final RealmService _realmService = RealmService.instance;
  final FirestoreService _firestoreService = FirestoreService.instance;
  final GeminiService _geminiService = GeminiService.instance;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      print('Initializing PhraseController...');
      
      // Inicializar Realm
      await _realmService.initialize();
      print('Realm initialized');
      
      // Inicializar Gemini
      await _geminiService.initialize();
      print('Gemini initialized');
      
      // Obtener frase inicial
      await loadDailyPhrase();
      
      _isInitialized = true;
      print('PhraseController initialization complete');
      
    } catch (e) {
      _setError('Error al inicializar la aplicación: $e');
      print('Error initializing PhraseController: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Cargar frase del día siguiendo el flujo del diagrama
  Future<void> loadDailyPhrase() async {
    _setLoading(true);
    _clearError();
    
    try {
      print('Loading daily phrase...');
      
      // Paso 1: Intentar generar nueva frase con Gemini
      final geminiPhrase = await _tryGeminiGeneration();
      if (geminiPhrase != null) {
        print('Got phrase from Gemini');
        _setCurrentPhrase(geminiPhrase);
        return;
      }
      
      // Paso 2: Si Gemini falla, intentar Firestore
      final firestorePhrase = await _tryFirestoreRetrieval();
      if (firestorePhrase != null) {
        print('Got phrase from Firestore');
        _setCurrentPhrase(firestorePhrase);
        return;
      }
      
      // Paso 3: Si Firestore falla, usar Realm local
      final realmPhrase = _realmService.getRandomPhrase();
      if (realmPhrase != null) {
        print('Got phrase from Realm');
        _realmService.markPhraseAsShown(realmPhrase);
        _setCurrentPhrase(realmPhrase);
        return;
      }
      
      // Paso 4: Si todo falla, mostrar mensaje
      _setError('No se pudieron cargar frases. Se actualizarán en próximos días.');
      
    } catch (e) {
      _setError('Error al cargar la frase: $e');
      print('Error loading daily phrase: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Intentar generar frase con Gemini
  Future<Phrase?> _tryGeminiGeneration() async {
    try {
      final generatedText = await _geminiService.generateMotivationalPhrase();
      if (generatedText != null && generatedText.isNotEmpty) {
        // Guardar en Realm
        final realmPhrase = _realmService.addPhrase(generatedText, 'gemini');
        
        // Intentar guardar en Firestore también
        if (realmPhrase != null) {
          final phraseJson = PhraseJson(
            id: realmPhrase.id,
            text: realmPhrase.text,
            createdAt: realmPhrase.createdAt,
            source: realmPhrase.source,
          );
          
          // No esperar a que Firestore termine, es async
          _firestoreService.savePhrase(phraseJson).then((success) {
            if (success) {
              print('Phrase saved to Firestore');
            } else {
              print('Failed to save phrase to Firestore');
            }
          });
          
          _realmService.markPhraseAsShown(realmPhrase);
          return realmPhrase;
        }
      }
    } catch (e) {
      print('Error in Gemini generation: $e');
    }
    return null;
  }
  
  // Intentar obtener frase de Firestore
  Future<Phrase?> _tryFirestoreRetrieval() async {
    try {
      final phraseJson = await _firestoreService.getRandomPhrase();
      if (phraseJson != null) {
        // Guardar en Realm si no existe
        final realmPhrase = _realmService.addPhrase(phraseJson.text, 'firestore');
        if (realmPhrase != null) {
          _realmService.markPhraseAsShown(realmPhrase);
          return realmPhrase;
        }
      }
    } catch (e) {
      print('Error in Firestore retrieval: $e');
    }
    return null;
  }
  
  // Obtener siguiente frase (para cuando el usuario toque la frase actual)
  Future<void> getNextPhrase() async {
    await loadDailyPhrase();
  }
  
  // Forzar recarga de frase
  Future<void> forceReload() async {
    await loadDailyPhrase();
  }
  
  // Métodos auxiliares para manejar estado
  void _setCurrentPhrase(Phrase? phrase) {
    _currentPhrase = phrase;
    _clearError();
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _realmService.dispose();
    super.dispose();
  }
}
