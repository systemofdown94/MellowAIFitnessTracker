import SwiftUI

enum TabState: Identifiable, CaseIterable {
    case session
    case exercises
    case history
    case settings
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .session:
                "Session"
            case .exercises:
                "Exercised"
            case .history:
                "History"
            case .settings:
                "Settings"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .session:
                    .Images.Tab.session
            case .exercises:
                    .Images.Tab.exercises
            case .history:
                    .Images.Tab.history
            case .settings:
                    .Images.Tab.settings
        }
    }
}
