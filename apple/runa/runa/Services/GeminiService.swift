//
//  GeminiService.swift
//  runa
//
//  Created by JOSE ZARABANDA on 7/30/25.
//

import Foundation
import FirebaseAI

class GeminiService: ObservableObject {
    static let shared = GeminiService()
    
    private var firebaseAI: FirebaseAI?
    private var model: GenerativeModel?
    private var isInitialized = false
    
    // Configuración del modelo
    private let modelName = "gemini-2.5-flash"
    
    private init() {}
    
    func initialize() async throws {
        do {
            print("🔄 Initializing Firebase AI Logic...")
            
            // Initialize Firebase AI Logic with Google AI backend (Gemini Developer API)
            firebaseAI = FirebaseAI.firebaseAI(backend: .googleAI())
            
            // Create the generative model instance
            model = firebaseAI?.generativeModel(modelName: modelName)
            
            isInitialized = true
            
            print("✅ Firebase AI Logic (Gemini) initialized successfully")
            print("📱 Model: \(modelName)")
            print("🔗 Backend: Gemini Developer API")
            
        } catch {
            print("❌ Error initializing Firebase AI Logic: \(error)")
            isInitialized = false
            throw GeminiError.initializationFailed
        }
    }
    
    func generateMotivationalPhrase() async throws -> String {
        guard isInitialized else {
            print("⚠️ Gemini service not initialized properly")
            throw GeminiError.notInitialized
        }
        
        guard let model = model else {
            print("⚠️ Modelo de Firebase AI Logic no configurado. Usando fallback...")
            return getFallbackPhrase()
        }
        
        // Prompt optimizado para generar frases motivacionales
        let prompt = """
        Genera una frase motivacional corta en español que inspire y motive a las personas a seguir adelante en su vida diaria.

        Requisitos:
        - Máximo 80 caracteres
        - Mensaje positivo y esperanzador
        - En español
        - SIN comillas de ningún tipo (ni " ni " ni " ni ' ni ')
        - SIN símbolos especiales al inicio o final
        - Enfocada en: superación personal, perseverancia, confianza, o logro de metas
        - Evita clichés muy comunes
        - Solo texto plano, sin formato

        Responde únicamente con la frase limpia, sin comillas, sin explicaciones adicionales.
        """
        
        do {
            print("🤖 Generating phrase with Gemini...")
            
            // Enviar request a Gemini usando Firebase AI Logic
            let response = try await model.generateContent(prompt)
            
            guard let responseText = response.text, !responseText.isEmpty else {
                print("⚠️ Empty response from Gemini")
                throw GeminiError.emptyResponse
            }
            
            // Limpiar y procesar la respuesta
            var cleanedText = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Remover todos los tipos de comillas usando replacingOccurrences individuales
            cleanedText = cleanedText.replacingOccurrences(of: "\"", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "'", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "\u{201C}", with: "") // "
            cleanedText = cleanedText.replacingOccurrences(of: "\u{201D}", with: "") // "
            cleanedText = cleanedText.replacingOccurrences(of: "\u{2018}", with: "") // '
            cleanedText = cleanedText.replacingOccurrences(of: "\u{2019}", with: "") // '
            cleanedText = cleanedText.replacingOccurrences(of: "«", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "»", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "‹", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "›", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "`", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "´", with: "")
            cleanedText = cleanedText.replacingOccurrences(of: "¨", with: "")
            
            // Remover cualquier carácter invisible o de control al inicio y final
            cleanedText = cleanedText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet.controlCharacters))
            
            // Capitalizar primera letra si es necesario
            if !cleanedText.isEmpty {
                cleanedText = cleanedText.prefix(1).uppercased() + cleanedText.dropFirst()
            }
            
            // Verificar longitud y truncar si es necesario
            if cleanedText.count > 120 {
                cleanedText = String(cleanedText.prefix(117)) + "..."
            }
            
            print("✅ Generated phrase (real): \"\(cleanedText)\"")
            return cleanedText
            
        } catch {
            print("❌ Error generating phrase with Gemini: \(error)")
            
            // Detectar tipos de error específicos
            let errorString = error.localizedDescription.lowercased()
            if errorString.contains("quota") ||
               errorString.contains("limit") ||
               errorString.contains("resource_exhausted") ||
               errorString.contains("rate limit") {
                print("🚫 Gemini quota/rate limit exceeded")
                throw GeminiError.quotaExceeded
            } else if errorString.contains("api key") ||
                      errorString.contains("authentication") ||
                      errorString.contains("permission") {
                print("🔑 Authentication/API key error")
                throw GeminiError.authenticationError
            } else if errorString.contains("network") ||
                      errorString.contains("connection") {
                print("🌐 Network connectivity error")
                throw GeminiError.networkError
            }
            
            throw GeminiError.unknownError(error.localizedDescription)
        }
    }
    
    private func getFallbackPhrase() -> String {
        let fallbackPhrases = [
            "Tu potencial no conoce límites, solo tú los defines.",
            "Cada obstáculo es una oportunidad disfrazada.",
            "El éxito comienza con un solo paso decidido.",
            "Tus sueños son el mapa hacia tu grandeza.",
            "La perseverancia convierte lo imposible en inevitable.",
            "Eres el arquitecto de tu propio destino.",
            "Cada día es una nueva oportunidad para brillar.",
            "La confianza en ti mismo es tu superpoder.",
            "Los desafíos de hoy son las victorias de mañana.",
            "Tu actitud determina tu altitud en la vida."
        ]
        
        let randomIndex = Int(Date().timeIntervalSince1970) % fallbackPhrases.count
        let selectedPhrase = fallbackPhrases[randomIndex]
        
        print("✅ Generated phrase (fallback): \"\(selectedPhrase)\"")
        return selectedPhrase
    }
    
    func isGeminiAvailable() async -> Bool {
        guard isInitialized else {
            return false
        }
        
        guard let model = model else {
            print("✅ Gemini available (fallback mode)")
            return true
        }
        
        do {
            print("🔍 Testing Gemini availability...")
            
            // Hacer una consulta simple para verificar que funciona
            let response = try await model.generateContent("Hola")
            
            let isAvailable = response.text != nil && !response.text!.isEmpty
            print(isAvailable ? "✅ Gemini is available (real)" : "❌ Gemini test failed")
            
            return isAvailable
        } catch {
            print("❌ Gemini availability check failed: \(error)")
            return false
        }
    }
    
    func createPhraseFromGemini() async throws -> Phrase {
        let text = try await generateMotivationalPhrase()
        
        // Generar un ID único basado en timestamp
        let id = Int(Date().timeIntervalSince1970)
        
        let phrase = Phrase()
        phrase.id = id
        phrase.text = text
        phrase.createdAt = Date()
        phrase.source = "gemini"
        phrase.isShown = false
        
        return phrase
    }
    
    func getServiceInfo() -> [String: Any] {
        return [
            "isInitialized": isInitialized,
            "modelName": modelName,
            "hasModel": model != nil,
            "backend": model != nil ? "Firebase AI Logic (Real)" : "Firebase AI Logic (Fallback)",
            "mode": model != nil ? "production" : "fallback"
        ]
    }
}

enum GeminiError: Error, LocalizedError {
    case notInitialized
    case initializationFailed
    case quotaExceeded
    case authenticationError
    case networkError
    case emptyResponse
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "Gemini service not initialized"
        case .initializationFailed:
            return "Failed to initialize Firebase AI Logic"
        case .quotaExceeded:
            return "Gemini API quota exceeded"
        case .authenticationError:
            return "Authentication error with Gemini API"
        case .networkError:
            return "Network connectivity error"
        case .emptyResponse:
            return "Empty response from Gemini API"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}
