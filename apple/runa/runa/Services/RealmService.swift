import Foundation
import RealmSwift

class RealmService: ObservableObject {
    static let shared = RealmService()
    
    private init() {}
    
    // Thread-safe Realm instance getter - creates new instance per thread
    private func getRealm() throws -> Realm {
        return try Realm()
    }
    
    @Published var phrases: [Phrase] = []
    
    @MainActor
    func loadPhrases() {
        Task {
            do {
                let realm = try getRealm()
                let realmPhrases = realm.objects(Phrase.self)
                await MainActor.run {
                    self.phrases = Array(realmPhrases)
                }
            } catch {
                print("Error loading phrases from Realm: \(error)")
            }
        }
    }
    
    func savePhrases(_ phrasesToSave: [Phrase]) {
        Task {
            do {
                let realm = try getRealm()
                try realm.write {
                    realm.add(phrasesToSave, update: .modified)
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error saving phrases to Realm: \(error)")
            }
        }
    }
    
    @MainActor
    func clearAllPhrases() {
        Task {
            do {
                let realm = try getRealm()
                try realm.write {
                    let allPhrases = realm.objects(Phrase.self)
                    realm.delete(allPhrases)
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error clearing phrases from Realm: \(error)")
            }
        }
    }
    
    func addPhrase(_ phrase: Phrase) {
        Task {
            do {
                let realm = try getRealm()
                
                // Create a new unmanaged Phrase object to avoid threading issues
                let newPhrase = Phrase()
                newPhrase.id = phrase.id
                newPhrase.text = phrase.text
                newPhrase.source = phrase.source
                newPhrase.createdAt = phrase.createdAt
                newPhrase.isShown = phrase.isShown
                newPhrase.lastShownAt = phrase.lastShownAt
                
                try realm.write {
                    realm.add(newPhrase, update: .modified)
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error adding phrase to Realm: \(error)")
            }
        }
    }
    
    func addPhraseAsync(_ phrase: Phrase) async throws {
        let realm = try getRealm()
        
        // Create a new unmanaged Phrase object to avoid threading issues
        let newPhrase = Phrase()
        newPhrase.id = phrase.id
        newPhrase.text = phrase.text
        newPhrase.source = phrase.source
        newPhrase.createdAt = phrase.createdAt
        newPhrase.isShown = phrase.isShown
        newPhrase.lastShownAt = phrase.lastShownAt
        
        try realm.write {
            realm.add(newPhrase, update: .modified)
        }
        
        await MainActor.run {
            self.loadPhrases()
        }
    }
    
    @MainActor
    func updatePhrase(_ phrase: Phrase) {
        Task {
            do {
                let realm = try getRealm()
                try realm.write {
                    realm.add(phrase, update: .modified)
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error updating phrase in Realm: \(error)")
            }
        }
    }
    
    @MainActor
    func deletePhrase(_ phrase: Phrase) {
        Task {
            do {
                let realm = try getRealm()
                if let phraseToDelete = realm.object(ofType: Phrase.self, forPrimaryKey: phrase.id) {
                    try realm.write {
                        realm.delete(phraseToDelete)
                    }
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error deleting phrase from Realm: \(error)")
            }
        }
    }
    
    func getPhraseCount() -> Int {
        do {
            let realm = try getRealm()
            return realm.objects(Phrase.self).count
        } catch {
            print("Error getting phrase count from Realm: \(error)")
            return 0
        }
    }
    
    func getPhrasesCount() -> Int {
        return getPhraseCount()
    }
    
    func getRandomPhrase() -> Phrase? {
        do {
            let realm = try getRealm()
            let phrases = realm.objects(Phrase.self)
            guard !phrases.isEmpty else { return nil }
            let randomIndex = Int.random(in: 0..<phrases.count)
            return phrases[randomIndex]
        } catch {
            print("Error getting random phrase from Realm: \(error)")
            return nil
        }
    }
    
    // Methods needed by PhraseController
    func initialize() async throws {
        // Already initialized when creating Realm instance
        await loadPhrases()
    }
    
    func getAllPhrases() -> Results<Phrase>? {
        do {
            let realm = try getRealm()
            return realm.objects(Phrase.self)
        } catch {
            print("Error getting all phrases from Realm: \(error)")
            return nil
        }
    }
    
    func markPhraseAsShown(_ phrase: Phrase) throws {
        // Since this is called synchronously from other parts of the code,
        // we need to handle it in a thread-safe way
        let phraseId = phrase.id
        
        Task {
            do {
                let realm = try getRealm()
                if let managedPhrase = realm.object(ofType: Phrase.self, forPrimaryKey: phraseId) {
                    try realm.write {
                        managedPhrase.isShown = true
                        managedPhrase.lastShownAt = Date()
                    }
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error marking phrase as shown: \(error)")
            }
        }
    }
    
    func markPhraseAsShownAsync(_ phrase: Phrase) async throws {
        let phraseId = phrase.id
        let realm = try getRealm()
        
        if let managedPhrase = realm.object(ofType: Phrase.self, forPrimaryKey: phraseId) {
            try realm.write {
                managedPhrase.isShown = true
                managedPhrase.lastShownAt = Date()
            }
        }
        
        await MainActor.run {
            self.loadPhrases()
        }
    }
    
    func getUnshownPhrases() -> Results<Phrase>? {
        do {
            let realm = try getRealm()
            return realm.objects(Phrase.self).filter("isShown == false")
        } catch {
            print("Error getting unshown phrases from Realm: \(error)")
            return nil
        }
    }
    
    func getRandomUnshownPhrase() -> Phrase? {
        guard let unshownPhrases = getUnshownPhrases(), !unshownPhrases.isEmpty else {
            // Si no hay frases no mostradas, resetear y devolver una aleatoria
            Task {
                await resetAllPhrasesAsUnshownAsync()
            }
            return getRandomPhrase()
        }
        
        let randomIndex = Int.random(in: 0..<unshownPhrases.count)
        return unshownPhrases[randomIndex]
    }
    
    @MainActor
    func resetAllPhrasesAsUnshown() throws {
        Task {
            do {
                let realm = try getRealm()
                try realm.write {
                    let allPhrases = realm.objects(Phrase.self)
                    for phrase in allPhrases {
                        phrase.isShown = false
                        phrase.lastShownAt = nil
                    }
                }
                await MainActor.run {
                    self.loadPhrases()
                }
            } catch {
                print("Error resetting phrases: \(error)")
            }
        }
    }
    
    @MainActor
    func resetAllPhrasesAsUnshownAsync() async {
        do {
            let realm = try getRealm()
            try realm.write {
                let allPhrases = realm.objects(Phrase.self)
                for phrase in allPhrases {
                    phrase.isShown = false
                    phrase.lastShownAt = nil
                }
            }
            await MainActor.run {
                self.loadPhrases()
            }
        } catch {
            print("Error resetting phrases: \(error)")
        }
    }
}