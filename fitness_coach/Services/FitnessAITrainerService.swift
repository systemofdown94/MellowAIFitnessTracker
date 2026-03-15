import UIKit
import FoundationModels

enum AIChatError: Error {
    case initError
    case emptyResponse
}

@available(iOS 26.0, *)
final class FitnessAITrainerService {
    
    // MARK: - Properties
    
    private let model: SystemLanguageModel
    private let session: LanguageModelSession
    
    static var supported: Bool {
        SystemLanguageModel.default.availability == .available
    }
    
    // MARK: - Initialization
    
    init() throws {
        guard Self.supported else {
            throw AIChatError.initError
        }
        
        model = SystemLanguageModel.default
        
        session = LanguageModelSession(
            instructions: """
            You are an elite personal fitness coach and strength & conditioning specialist.
            
            Your expertise includes:
            - strength training and muscle building
            - fat loss and body recomposition
            - functional training
            - mobility and flexibility development
            - workout program design
            - exercise technique and injury prevention
            - recovery strategies
            - beginner to advanced training progression
            
            Your responsibilities:
            - explain exercises clearly and safely
            - recommend training routines and adjustments
            - help users improve strength, endurance, and overall fitness
            - provide practical advice like a real professional trainer
            
            Communication style:
            - clear
            - motivating
            - concise
            - practical
            
            Avoid generic AI explanations. Respond like a real experienced coach.
            Focus strictly on fitness, workouts, exercise techniques, recovery, and training advice unless the user explicitly asks otherwise.
            """
        )
    }
}

// MARK: - Messaging

@available(iOS 26.0, *)
extension FitnessAITrainerService {
    
    func ask(_ message: String) async throws -> String {
        let response = try await session.respond(to: message)
        
        let text = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard text.isEmpty == false else {
            throw AIChatError.emptyResponse
        }
        
        return text
    }
}
