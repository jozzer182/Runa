//
//  RunaWidgetEntryView.swift
//  RunaWidget
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import SwiftUI
import WidgetKit

struct RunaWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo degradado similar a la app
                backgroundGradient
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    Spacer()
                    
                    // Contenido principal
                    phraseContentView
                    
                    Spacer()
                    
                    // Footer
                    footerView
                }
                .padding(family == .systemMedium ? 12 : 16)
            }
        }
        .widgetURL(URL(string: "runa://open"))
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.2),
                Color(red: 0.2, green: 0.1, blue: 0.3),
                Color(red: 0.1, green: 0.2, blue: 0.4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Runa")
                    .font(family == .systemMedium ? .headline : .title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if family == .systemLarge {
                    Text("Tu motivación diaria")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Indicador de tiempo
            Text(timeDisplayText)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var phraseContentView: some View {
        VStack(spacing: family == .systemMedium ? 8 : 12) {
            // Comillas decorativas
            if family == .systemLarge {
                Text("❝")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            // Texto de la frase
            Text(entry.phrase)
                .font(family == .systemMedium ? .system(size: 14, weight: .medium) : .system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(family == .systemMedium ? 2 : 4)
                .minimumScaleFactor(0.8)
            
            if family == .systemLarge {
                Text("❞")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }
    
    private var footerView: some View {
        HStack {
            // Indicador de origen
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 6, height: 6)
                
                Text("Widget")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            if family == .systemLarge {
                Text("Toca para abrir la app")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
    
    private var timeDisplayText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: entry.date)
    }
}

#Preview(as: .systemMedium) {
    RunaWidget()
} timeline: {
    SimpleEntry(date: .now, phrase: "El éxito no es final, el fracaso no es fatal: es el coraje de continuar lo que cuenta.")
}

#Preview(as: .systemLarge) {
    RunaWidget()
} timeline: {
    SimpleEntry(date: .now, phrase: "No esperes por el momento perfecto, toma el momento y hazlo perfecto.")
}
