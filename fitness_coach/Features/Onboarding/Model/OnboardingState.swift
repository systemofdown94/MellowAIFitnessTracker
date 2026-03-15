import Foundation

enum OnboardingState: Int, Identifiable, CaseIterable {
    case page1 = 0
    case page2
    case page3
    
    var id: Self {
        self
    }
}
