import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    
    private let udService = UDService.shared
    
    @Published var navPath: [HistoryScreen] = []
    
    @Published private(set) var sessions: [Session] = []
}

// MARK: - Public API:
extension HistoryViewModel {
    func loadHistory() {
        Task {
            let sessions = await self.udService.value(forKey: .session, as: [Session].self) ?? []
            
            await MainActor.run {
                self.sessions = sessions
            }
        }
    }
    
    func save(_ session: Session) {
        Task {
            var sessions = await self.udService.value(forKey: .session, as: [Session].self) ?? []
            
            if let index = sessions.firstIndex(where: { $0.id == session.id }),
            let uiIndex = self.sessions.firstIndex(where: { $0.id == session.id }) {
                sessions[index] = session
                
                await self.udService.set(sessions, forKey: .session)
                
                let _ = await MainActor.run {
                    self.sessions[uiIndex] = session
                    self.navPath = []
                }
            }
        }
    }
    
    func remove(_ session: Session) {
        Task {
            var sessions = await self.udService.value(forKey: .session, as: [Session].self) ?? []
            
            if let index = sessions.firstIndex(where: { $0.id == session.id }),
            let uiIndex = self.sessions.firstIndex(where: { $0.id == session.id }) {
                sessions.remove(at: index)
                
                await self.udService.set(sessions, forKey: .session)
                
                let _ = await MainActor.run {
                    self.sessions.remove(at: uiIndex)
                }
            }
        }
    }
}
