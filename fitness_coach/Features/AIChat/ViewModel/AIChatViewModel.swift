import Foundation
import Combine

@available(iOS 26.0, *)
final class AIChatViewModel: ObservableObject {
    
    private var coachService: FitnessAITrainerService?
    
    @Published var text = ""
    
    @Published private(set) var messages: [Message] = [Message(isMock: true)]
    @Published private(set) var isLoading = false
    
    init() {
        do {
            coachService = try FitnessAITrainerService()
        } catch let error as AIChatError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Public API:
@available(iOS 26.0, *)
extension AIChatViewModel {
    func sendMessage() {
        isLoading = true
        let text = self.text
        self.text = ""
        
        messages.append(.init(text: text, isUser: true))
        
        Task {
            let response = try? await self.coachService?.ask(text) ?? ""
            
            await MainActor.run {
                self.isLoading = false
                self.messages.append(.init(text: response ?? "", isUser: false))
            }
        }
    }
}
