import Foundation
import UserNotifications

final class NotificationPermissionService {
    
    static let instance = NotificationPermissionService()
    
    enum PermissionState {
        case granted
        case rejected
        case unknown
    }
    
    private init() {}
    
    func fetchCurrentState(completion: @escaping (PermissionState) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            let state = self.convertStatus(settings.authorizationStatus)
            
            DispatchQueue.main.async {
                completion(state)
            }
        }
    }
    
    func askForPermission(completion: @escaping (PermissionState) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            self.fetchCurrentState(completion: completion)
        }
    }
    
    private func convertStatus(_ status: UNAuthorizationStatus) -> PermissionState {
        switch status {
        case .authorized, .provisional, .ephemeral:
            return .granted
            
        case .denied:
            return .rejected
            
        case .notDetermined:
            return .unknown
            
        @unknown default:
            return .unknown
        }
    }
}
