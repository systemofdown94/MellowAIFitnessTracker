import Foundation
import Combine

final class AppTabCoordinator: ObservableObject {
    
    static var shared = AppTabCoordinator()

    @Published var currentState: TabState = .session

    @Published var shouldShowTabBar = true
    
    private init() {}
}
