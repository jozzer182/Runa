//
//  ContentView.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingWidgetConfig = false
    
    var body: some View {
        NavigationView {
            PhraseView()
                .navigationBarHidden(false)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingWidgetConfig = true
                        }) {
                            Image(systemName: "rectangle.stack.fill")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .sheet(isPresented: $showingWidgetConfig) {
                    WidgetConfigView()
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
