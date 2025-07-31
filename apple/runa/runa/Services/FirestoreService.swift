//
//  FirestoreService.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/30/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let collectionName = "phrases"
    
    private init() {}
    
    func savePhrase(_ phrase: Phrase) async throws {
        let data: [String: Any] = [
            "id": phrase.id,
            "text": phrase.text,
            "createdAt": phrase.createdAt ?? Date(),
            "source": phrase.source,
            "isShown": phrase.isShown,
            "lastShownAt": phrase.lastShownAt ?? Date()
        ]
        
        try await db.collection(collectionName).document(String(phrase.id)).setData(data)
        print("✅ Phrase saved to Firestore: \(phrase.text)")
    }
    
    func savePhraseData(_ phraseData: PhraseData) async throws {
        let data: [String: Any] = [
            "id": phraseData.id,
            "text": phraseData.text,
            "createdAt": phraseData.createdAt ?? Date(),
            "source": phraseData.source,
            "isShown": phraseData.isShown,
            "lastShownAt": phraseData.lastShownAt ?? Date()
        ]
        
        try await db.collection(collectionName).document(String(phraseData.id)).setData(data)
        print("✅ Phrase data saved to Firestore: \(phraseData.text)")
    }
    
    func getRandomPhrase() async throws -> Phrase? {
        let snapshot = try await db.collection(collectionName).getDocuments()
        
        guard !snapshot.documents.isEmpty else {
            print("❌ No phrases found in Firestore")
            return nil
        }
        
        let randomDocument = snapshot.documents.randomElement()
        guard let data = randomDocument?.data() else {
            return nil
        }
        
        return try parseFirestoreData(data)
    }
    
    func getAllPhrases() async throws -> [Phrase] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        
        var phrases: [Phrase] = []
        for document in snapshot.documents {
            if let phrase = try? parseFirestoreData(document.data()) {
                phrases.append(phrase)
            }
        }
        
        return phrases
    }
    
    func getPhrasesCount() async throws -> Int {
        let snapshot = try await db.collection(collectionName).count.getAggregation(source: .server)
        return Int(snapshot.count)
    }
    
    private func parseFirestoreData(_ data: [String: Any]) throws -> Phrase {
        guard let id = data["id"] as? Int,
              let text = data["text"] as? String,
              let source = data["source"] as? String else {
            throw FirestoreError.invalidData
        }
        
        let phrase = Phrase()
        phrase.id = id
        phrase.text = text
        phrase.source = source
        
        if let timestamp = data["createdAt"] as? Timestamp {
            phrase.createdAt = timestamp.dateValue()
        }
        
        if let isShown = data["isShown"] as? Bool {
            phrase.isShown = isShown
        }
        
        if let timestamp = data["lastShownAt"] as? Timestamp {
            phrase.lastShownAt = timestamp.dateValue()
        }
        
        return phrase
    }
    
    func deletePhraseById(_ id: Int) async throws {
        try await db.collection(collectionName).document(String(id)).delete()
        print("✅ Phrase deleted from Firestore: ID \(id)")
    }
    
    func checkConnection() async -> Bool {
        do {
            _ = try await db.collection("test").limit(to: 1).getDocuments()
            return true
        } catch {
            print("❌ Firestore connection failed: \(error)")
            return false
        }
    }
}

enum FirestoreError: Error, LocalizedError {
    case invalidData
    case connectionFailed
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data format from Firestore"
        case .connectionFailed:
            return "Failed to connect to Firestore"
        case .saveFailed:
            return "Failed to save data to Firestore"
        }
    }
}
