//
//  Phrase.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/30/25.
//

import Foundation
import RealmSwift

class Phrase: Object, Identifiable {
    @Persisted var id: Int = 0
    @Persisted var text: String = ""
    @Persisted var createdAt: Date?
    @Persisted var source: String = "base" // 'base', 'gemini', 'firestore'
    @Persisted var isShown: Bool = false // Para controlar qué frases ya fueron mostradas
    @Persisted var lastShownAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, text: String, createdAt: Date?, source: String) {
        self.init()
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.source = source
    }
}

// Thread-safe data structure for passing phrase data between services
struct PhraseData {
    let id: Int
    let text: String
    let createdAt: Date?
    let source: String
    let isShown: Bool
    let lastShownAt: Date?
}

// Estructura para decodificar JSON
struct PhraseJSON: Codable, Identifiable {
    let id: Int
    let text: String
    let createdAt: String?
    let source: String
    
    var phraseObject: Phrase {
        let phrase = Phrase()
        phrase.id = id
        phrase.text = text
        phrase.source = source
        if let createdAtString = createdAt {
            phrase.createdAt = ISO8601DateFormatter().date(from: createdAtString)
        }
        return phrase
    }
}

struct PhrasesContainer: Codable {
    let phrases: [PhraseJSON]
}
