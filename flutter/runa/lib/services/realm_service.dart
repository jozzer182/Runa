import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phrase.dart';

class RealmService {
  static RealmService? _instance;
  static RealmService get instance => _instance ??= RealmService._();
  
  RealmService._();
  
  Realm? _realm;
  
  Future<void> initialize() async {
    try {
      final config = Configuration.local([Phrase.schema]);
      _realm = Realm(config);
      
      // Verificar si ya hay datos en Realm
      final count = _realm!.all<Phrase>().length;
      if (count == 0) {
        await _loadBasePhrases();
      }
    } catch (e) {
      print('Error initializing Realm: $e');
      rethrow;
    }
  }
  
  Future<void> _loadBasePhrases() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/base_phrases.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> phrasesJson = jsonData['phrases'];
      
      _realm!.write(() {
        for (final phraseData in phrasesJson) {
          final phraseJson = PhraseJson.fromJson(phraseData);
          final phrase = phraseJson.toRealmObject();
          _realm!.add(phrase);
        }
      });
      
      // Marcar que las frases base fueron cargadas
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('base_phrases_loaded', true);
      
      print('Base phrases loaded successfully: ${phrasesJson.length} phrases');
    } catch (e) {
      print('Error loading base phrases: $e');
      rethrow;
    }
  }
  
  // Obtener frase aleatoria que no haya sido mostrada recientemente
  Phrase? getRandomPhrase() {
    if (_realm == null) return null;
    
    try {
      // Buscar frases no mostradas hoy
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final unshownPhrases = _realm!.all<Phrase>().where((p) => 
          p.lastShownAt == null || p.lastShownAt!.isBefore(startOfDay));
      
      if (unshownPhrases.isNotEmpty) {
        // Seleccionar una frase aleatoria de las no mostradas
        final randomIndex = DateTime.now().millisecondsSinceEpoch % unshownPhrases.length;
        return unshownPhrases.elementAt(randomIndex);
      }
      
      // Si todas fueron mostradas hoy, obtener cualquiera
      final allPhrases = _realm!.all<Phrase>();
      if (allPhrases.isNotEmpty) {
        final randomIndex = DateTime.now().millisecondsSinceEpoch % allPhrases.length;
        return allPhrases.elementAt(randomIndex);
      }
      
      return null;
    } catch (e) {
      print('Error getting random phrase: $e');
      return null;
    }
  }
  
  // Marcar frase como mostrada
  void markPhraseAsShown(Phrase phrase) {
    if (_realm == null) return;
    
    try {
      _realm!.write(() {
        phrase.isShown = true;
        phrase.lastShownAt = DateTime.now();
      });
    } catch (e) {
      print('Error marking phrase as shown: $e');
    }
  }
  
  // Agregar nueva frase (desde Gemini o Firestore)
  Phrase? addPhrase(String text, String source) {
    if (_realm == null) return null;
    
    try {
      // Generar nuevo ID
      final allPhrases = _realm!.all<Phrase>();
      final maxId = allPhrases.isEmpty ? 0 : allPhrases.map((p) => p.id).reduce((a, b) => a > b ? a : b);
      
      final phrase = Phrase(
        maxId + 1,
        text,
        source,
        createdAt: DateTime.now(),
      );
      
      _realm!.write(() {
        _realm!.add(phrase);
      });
      
      return phrase;
    } catch (e) {
      print('Error adding phrase: $e');
      return null;
    }
  }
  
  // Obtener todas las frases
  List<Phrase> getAllPhrases() {
    if (_realm == null) return [];
    return _realm!.all<Phrase>().toList();
  }
  
  // Verificar si Realm está inicializado
  bool get isInitialized => _realm != null;
  
  void dispose() {
    _realm?.close();
    _realm = null;
  }
}
