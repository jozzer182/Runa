//
//  WidgetProvider.swift
//  RunaWidget
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import WidgetKit
import SwiftUI

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
        
        // Intentar obtener frases del almacenamiento compartido
        let phrases = await getPhrasesFromStorage()
        
        // Crear entradas para las próximas 24 horas, actualizando cada 4 horas
        for hourOffset in stride(from: 0, to: 24, by: 4) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let randomPhrase = phrases.randomElement() ?? "Tu potencial es infinito. ¡Hazlo realidad!"
            
            let entry = SimpleEntry(date: entryDate, phrase: randomPhrase)
            entries.append(entry)
        }
        
        return entries
    }
    
    private func getPhrasesFromStorage() async -> [String] {
        // Intentar leer desde UserDefaults compartido
        if let sharedDefaults = UserDefaults(suiteName: "group.com.josezarabanda.runa") {
            // Intentar obtener la frase actual primero
            if let currentPhrase = sharedDefaults.string(forKey: "current_phrase"),
               !currentPhrase.isEmpty {
                return [currentPhrase]
            }
            
            // Si no hay frase actual, usar las frases guardadas
            if let savedPhrases = sharedDefaults.array(forKey: "widget_phrases") as? [String],
               !savedPhrases.isEmpty {
                return savedPhrases
            }
        }
        
        // Frases por defecto si no hay datos
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let phrase: String
}
