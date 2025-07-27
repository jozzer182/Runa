import 'package:realm/realm.dart';

part 'phrase.realm.dart';

@RealmModel()
class _Phrase {
  @PrimaryKey()
  late int id;
  
  late String text;
  
  DateTime? createdAt;
  
  late String source; // 'base', 'gemini', 'firestore'
  
  bool isShown = false; // Para controlar qué frases ya fueron mostradas
  
  DateTime? lastShownAt;
}

// Clase helper para JSON
class PhraseJson {
  final int id;
  final String text;
  final DateTime? createdAt;
  final String source;
  
  PhraseJson({
    required this.id,
    required this.text,
    this.createdAt,
    required this.source,
  });
  
  factory PhraseJson.fromJson(Map<String, dynamic> json) {
    return PhraseJson(
      id: json['id'] as int,
      text: json['text'] as String,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      source: json['source'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt?.toIso8601String(),
      'source': source,
    };
  }
  
  Phrase toRealmObject() {
    return Phrase(
      id,
      text,
      source,
      createdAt: createdAt,
    );
  }
}
