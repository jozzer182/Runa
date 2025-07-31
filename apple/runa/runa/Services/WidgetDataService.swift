//
//  WidgetDataService.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import Foundation
import WidgetKit

class WidgetDataService {
    static let shared = WidgetDataService()
    
    private let suiteName = "group.com.josezarabanda.runainspiracion"
    private let phrasesKey = "widget_phrases"
    private let currentPhraseKey = "current_phrase"
    private let lastUpdateKey = "last_update"
    
    private var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: suiteName)
    }
    
    private init() {}
    
    // MARK: - Update Widget Data
    
    func updateWidgetData(phrases: [String], currentPhrase: String? = nil) {
        guard let sharedDefaults = sharedDefaults else {
            print("❌ No se pudo acceder a UserDefaults compartido")
            return
        }
        
        // Guardar todas las frases disponibles
        sharedDefaults.set(phrases, forKey: phrasesKey)
        
        // Guardar la frase actual si se proporciona
        if let currentPhrase = currentPhrase {
            sharedDefaults.set(currentPhrase, forKey: currentPhraseKey)
        }
        
        // Actualizar timestamp
        sharedDefaults.set(Date(), forKey: lastUpdateKey)
        
        // Forzar sincronización
        sharedDefaults.synchronize()
        
        // Recargar todos los widgets
        reloadAllWidgets()
        
        print("✅ Datos del widget actualizados: \(phrases.count) frases")
    }
    
    func updateCurrentPhrase(_ phrase: String) {
        guard let sharedDefaults = sharedDefaults else { return }
        
        sharedDefaults.set(phrase, forKey: currentPhraseKey)
        sharedDefaults.set(Date(), forKey: lastUpdateKey)
        sharedDefaults.synchronize()
        
        reloadAllWidgets()
        
        print("✅ Frase actual del widget actualizada: \(phrase.prefix(50))...")
    }
    
    // MARK: - Retrieve Widget Data
    
    func getWidgetPhrases() -> [String] {
        guard let sharedDefaults = sharedDefaults else { return [] }
        return sharedDefaults.array(forKey: phrasesKey) as? [String] ?? []
    }
    
    func getCurrentPhrase() -> String? {
        guard let sharedDefaults = sharedDefaults else { return nil }
        return sharedDefaults.string(forKey: currentPhraseKey)
    }
    
    func getLastUpdateDate() -> Date? {
        guard let sharedDefaults = sharedDefaults else { return nil }
        return sharedDefaults.object(forKey: lastUpdateKey) as? Date
    }
    
    // MARK: - Widget Management
    
    private func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reloadWidgets() {
        reloadAllWidgets()
    }
    
    // MARK: - Data Validation
    
    func validateAndPreparePhrasesForWidget(from phrases: [Phrase]) -> [String] {
        let validPhrases = phrases
            .compactMap { phrase -> String? in
                // Filtrar frases muy largas para el widget
                guard !phrase.text.isEmpty && phrase.text.count <= 200 else { return nil }
                return phrase.text
            }
            .prefix(50) // Limitar a 50 frases máximo
        
        return Array(validPhrases)
    }
    
    // MARK: - Debug Info
    
    func getDebugInfo() -> [String: Any] {
        guard sharedDefaults != nil else {
            return ["error": "No se pudo acceder a UserDefaults compartido"]
        }
        
        return [
            "phrases_count": getWidgetPhrases().count,
            "current_phrase": getCurrentPhrase() ?? "N/A",
            "last_update": getLastUpdateDate()?.description ?? "N/A",
            "suite_name": suiteName
        ]
    }
}
