//
//  RunaWidget.swift
//  RunaWidget
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import WidgetKit
import SwiftUI

struct RunaWidget: Widget {
    let kind: String = "RunaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RunaWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RunaWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Runa Motivacional")
        .description("Tu frase motivacional diaria.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    RunaWidget()
} timeline: {
    SimpleEntry(date: .now, phrase: "El éxito no es final, el fracaso no es fatal: es el coraje de continuar lo que cuenta.")
    SimpleEntry(date: .now, phrase: "No esperes por el momento perfecto, toma el momento y hazlo perfecto.")
}
