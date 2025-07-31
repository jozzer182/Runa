//
//  WidgetProvider.swift
//  RunaWidget
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import WidgetKit
import SwiftUI

// MARK: - SimpleEntry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let phrase: String
}

// MARK: - Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), phrase: "Cargando tu frase inspiradora...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), phrase: "Cada día es una nueva oportunidad para ser mejor que ayer.")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            let entries = await generateEntries()
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func generateEntries() async -> [SimpleEntry] {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Obtener frases del storage compartido
        let phrases = getPhrasesFromStorage()
        
        // Generar entradas para las próximas 24 horas (cada 4 horas)
        for hourOffset in stride(from: 0, to: 24, by: 4) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let phraseIndex = hourOffset / 4
            let selectedPhrase = phrases[phraseIndex % phrases.count]
            
            let entry = SimpleEntry(date: entryDate, phrase: selectedPhrase)
            entries.append(entry)
        }
        
        return entries
    }
    
    private func getPhrasesFromStorage() -> [String] {
        // Intentar obtener frases del App Group (compartido con la app principal)
        if let sharedDefaults = UserDefaults(suiteName: "group.com.josezarabanda.runainspiracion") {
            if let savedPhrases = sharedDefaults.array(forKey: "widget_phrases") as? [String], !savedPhrases.isEmpty {
                return savedPhrases
            }
        }
        
        // Si no hay frases guardadas, usar frases por defecto
        return getDefaultPhrases()
    }
    
    private func getDefaultPhrases() -> [String] {
        return [
            "El éxito no es final, el fracaso no es fatal: es el coraje de continuar lo que cuenta.",
            "No esperes por el momento perfecto, toma el momento y hazlo perfecto.",
            "Tu única limitación eres tú mismo.",
            "Los sueños no funcionan a menos que tú lo hagas.",
            "El futuro pertenece a quienes creen en la belleza de sus sueños.",
            "No cuentes los días, haz que los días cuenten.",
            "La vida es 10% lo que te pasa y 90% cómo reaccionas a ello.",
            "El primer paso hacia el éxito es intentarlo.",
            "Las oportunidades no suceden, las creas.",
            "Cree en ti mismo y todo será posible."
        ]
    }
}
