import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/phrase.dart';

class FirestoreService {
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();
  
  FirestoreService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'motivational_phrases';
  
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }
  
  // Guardar frase en Firestore
  Future<bool> savePhrase(PhraseJson phrase) async {
    try {
      if (!await hasInternetConnection()) {
        print('No internet connection');
        return false;
      }
      
      await _firestore.collection(_collection).doc(phrase.id.toString()).set(phrase.toJson());
      print('Phrase saved to Firestore: ${phrase.text}');
      return true;
    } catch (e) {
      print('Error saving phrase to Firestore: $e');
      return false;
    }
  }
  
  // Obtener frase aleatoria de Firestore
  Future<PhraseJson?> getRandomPhrase() async {
    try {
      if (!await hasInternetConnection()) {
        print('No internet connection');
        return null;
      }
      
      final snapshot = await _firestore.collection(_collection).get();
      
      if (snapshot.docs.isNotEmpty) {
        final randomIndex = DateTime.now().millisecondsSinceEpoch % snapshot.docs.length;
        final doc = snapshot.docs[randomIndex];
        return PhraseJson.fromJson(doc.data());
      }
      
      return null;
    } catch (e) {
      print('Error getting random phrase from Firestore: $e');
      return null;
    }
  }
  
  // Obtener todas las frases de Firestore
  Future<List<PhraseJson>> getAllPhrases() async {
    try {
      if (!await hasInternetConnection()) {
        print('No internet connection');
        return [];
      }
      
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => PhraseJson.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting all phrases from Firestore: $e');
      return [];
    }
  }
  
  // Verificar si hay frases en Firestore
  Future<bool> hasPhrasesInFirestore() async {
    try {
      if (!await hasInternetConnection()) {
        return false;
      }
      
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phrases in Firestore: $e');
      return false;
    }
  }
}
