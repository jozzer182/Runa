//
//  WidgetConfigView.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/31/25.
//

import SwiftUI
import WidgetKit

struct WidgetConfigView: View {
    @StateObject private var controller = PhraseController.shared
    @State private var isRefreshingWidget = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Widget Preview
                    widgetPreviewSection
                    
                    // Controls
                    widgetControlsSection
                    
                    // Info
                    widgetInfoSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Widget Configuration")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.stack.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("Widget de Runa")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Mantén la motivación siempre visible en tu pantalla principal")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var widgetPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vista Previa")
                .font(.headline)
            
            // Mock widget preview
            mockWidgetPreview
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var mockWidgetPreview: some View {
        ZStack {
            // Same gradient as the real widget
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                HStack {
                    Text("Runa")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Widget")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Text(controller.currentPhrase?.text ?? "Tu frase motivacional aparecerá aquí")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Spacer()
                
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 6, height: 6)
                    
                    Text("Actualizada")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(height: 150)
    }
    
    private var widgetControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Controles")
                .font(.headline)
            
            VStack(spacing: 12) {
                // Refresh Widget button
                Button(action: refreshWidget) {
                    HStack {
                        if isRefreshingWidget {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        
                        Text("Actualizar Widget")
                        
                        Spacer()
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(isRefreshingWidget)
                
                // How to add widget button
                Button(action: showAddWidgetInstructions) {
                    HStack {
                        Image(systemName: "plus.rectangle.on.rectangle")
                        
                        Text("Cómo añadir widget")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var widgetInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información")
                .font(.headline)
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "clock",
                    title: "Frecuencia de actualización",
                    value: "Cada 4 horas"
                )
                
                InfoRow(
                    icon: "textformat.size",
                    title: "Tamaños disponibles",
                    value: "Mediano y Grande"
                )
                
                InfoRow(
                    icon: "quote.bubble",
                    title: "Frases disponibles",
                    value: "\(controller.totalPhrasesCount) frases"
                )
                
                InfoRow(
                    icon: "wifi",
                    title: "Estado de conexión",
                    value: controller.getConnectionStatusText()
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    private func refreshWidget() {
        isRefreshingWidget = true
        
        Task {
            controller.refreshWidgetData()
            
            // Simular un pequeño delay para mostrar el loading
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            await MainActor.run {
                isRefreshingWidget = false
            }
        }
    }
    
    private func showAddWidgetInstructions() {
        let alert = UIAlertController(
            title: "Añadir Widget",
            message: """
            1. Mantén presionado en la pantalla principal
            2. Toca el botón "+" en la esquina superior izquierda
            3. Busca "Runa" en la lista
            4. Selecciona el tamaño deseado
            5. Toca "Añadir Widget"
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

#Preview {
    WidgetConfigView()
}
