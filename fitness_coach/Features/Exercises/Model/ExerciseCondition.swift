import SwiftUI

enum ExerciseCondition: Identifiable, CaseIterable, Codable {
    case good
    case normal
    case tired
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .good:
                "Good"
            case .normal:
                "Normal"
            case .tired:
                "Tired"
        }
    }
    
    var icon: String {
        switch self {
            case .good:
                "😍"
            case .normal:
                "🙂"
            case .tired:
                "😮‍💨"
        }
    }
    
    var color: Color {
        switch self {
            case .good:
                    .green
            case .normal:
                    .yellow
            case .tired:
                    .red
        }
    }
}
