//
//  PhraseView.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/30/25.
//

import SwiftUI

struct PhraseView: View {
    @StateObject private var controller = PhraseController.shared
    @State private var animatePhrase = false
    @State private var animateButton = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo degradado
                backgroundGradient
                
                VStack(spacing: 30) {
                    // Header
                    headerSection
                    
                    Spacer()
                    
                    // Contenido principal
                    mainContentSection(geometry: geometry)
                    
                    Spacer()
                    
                    // Footer
                    footerSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
        }
        .task {
            await controller.initialize()
        }
        .refreshable {
            await controller.forceRefreshPhrase()
        }
    }
    
    // MARK: - Background
    
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
        .ignoresSafeArea()
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Runa")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Botón de configuración del widget
                NavigationLink(destination: WidgetConfigView()) {
                    Image(systemName: "rectangle.stack")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.trailing, 8)
                
                connectionStatusIndicator
            }
            
            Text("Tu dosis diaria de motivación")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var connectionStatusIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color(controller.getConnectionStatusColor()))
                .frame(width: 8, height: 8)
            
            Text(controller.getConnectionStatusText())
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Main Content
    
    private func mainContentSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 30) {
            // Frase principal
            if controller.isLoading {
                loadingView
            } else if let phrase = controller.currentPhrase {
                phraseCard(phrase: phrase, geometry: geometry)
            } else if let errorMessage = controller.errorMessage {
                errorView(message: errorMessage)
            }
            
            // Botón de actualizar
            refreshButton
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.white)
            
            Text("Cargando tu frase del día...")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(height: 200)
    }
    
    private func phraseCard(phrase: Phrase, geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            
            // Texto de la frase
            Text(phrase.text)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 20)
                .scaleEffect(animatePhrase ? 1.0 : 0.9)
                .opacity(animatePhrase ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8), value: animatePhrase)
                        
            // Información de la frase
            phraseInfoSection(phrase: phrase)
        }
        .onAppear {
            animatePhrase = true
        }
        .onChange(of: phrase.id) { _ in
            animatePhrase = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatePhrase = true
            }
        }
    }
    
    private func phraseInfoSection(phrase: Phrase) -> some View {
        VStack(spacing: 8) {
            HStack {
                sourceTag(source: phrase.source)
                Spacer()
                if let lastUpdate = controller.lastUpdateTime {
                    timeTag(date: lastUpdate)
                }
            }
            
            if controller.totalPhrasesCount > 0 {
                Text("\(controller.totalPhrasesCount) frases disponibles")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.top, 16)
    }
    
    private func sourceTag(source: String) -> some View {
        Text(sourceDisplayName(source))
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(sourceColor(source).opacity(0.3))
            .foregroundColor(sourceColor(source))
            .clipShape(Capsule())
    }
    
    private func timeTag(date: Date) -> some View {
        Text(timeAgoString(date))
            .font(.caption2)
            .foregroundColor(.white.opacity(0.6))
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text(message)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(height: 200)
    }
    
    // MARK: - Refresh Button
    
    private var refreshButton: some View {
        Button(action: {
            HapticFeedback.light()
            animateButton = true
            
            Task {
                await controller.forceRefreshPhrase()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animateButton = false
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .medium))
                
                Text("Nueva frase")
                    .font(.system(size: 18, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(animateButton ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: animateButton)
        }
        .disabled(!controller.canRefresh())
        .opacity(controller.canRefresh() ? 1.0 : 0.6)
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("Comparte tu motivación")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            shareButton
        }
    }
    
    private var shareButton: some View {
        Button(action: shareCurrentPhrase) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                
                Text("Compartir")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
            )
        }
        .disabled(controller.currentPhrase == nil)
    }
    
    // MARK: - Helper Functions
    
    private func sourceDisplayName(_ source: String) -> String {
        switch source {
        case "base":
            return "Base"
        case "gemini":
            return "IA Generada"
        case "firestore":
            return "Comunidad"
        default:
            return "Desconocido"
        }
    }
    
    private func sourceColor(_ source: String) -> Color {
        switch source {
        case "base":
            return .blue
        case "gemini":
            return .purple
        case "firestore":
            return .green
        default:
            return .gray
        }
    }
    
    private func timeAgoString(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Hace un momento"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "Hace \(minutes) min"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "Hace \(hours)h"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    }
    
    private func shareCurrentPhrase() {
        guard let phrase = controller.currentPhrase else { return }
        
        let shareText = """
        "\(phrase.text)"
        
        - Runa App 🌟
        Tu dosis diaria de motivación
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

// MARK: - Haptic Feedback Helper

struct HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

// MARK: - Preview

#Preview {
    PhraseView()
}
