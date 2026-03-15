enum ExerciseIntencity: Identifiable, CaseIterable, Codable {
    case low
    case medium
    case high
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .low:
                "Low"
            case .medium:
                "Medium"
            case .high:
                "High"
        }
    }
    
    var multiplicator: Double {
        switch self {
            case .low:
                0.5
            case .medium:
                1
            case .high:
                1.5
        }
    }
}
