import Foundation
import Combine

final class SessionViewModel: ObservableObject {
    
    private let udService = UDService.shared
    
    @Published var sessionState: SessionState = .noActive
    @Published var navPath: [SessionScreen] = []
}

// MARK: - Public API:
extension SessionViewModel {
    func save(_ session: Session) {
        Task {
            var sessions = await self.udService.value(forKey: .session, as: [Session].self) ?? []
            
            sessions.append(session)
            
            await self.udService.set(sessions, forKey: .session)
            
            await MainActor.run {
                self.sessionState = .noActive
                self.navPath = []
            }
        }
    }
}
