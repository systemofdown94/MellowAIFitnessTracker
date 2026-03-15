import SwiftUI

struct Exercise: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    var name: String
    let type: ExerciseType
    var intencity: ExerciseIntencity?
    var duration: Int
    var caloriesPerMinute: String
    var condition: ExerciseCondition?
    
    var totalCalories: Int {
        Int(Double(duration * (Int(caloriesPerMinute) ?? 0)) * (intencity?.multiplicator ?? 1))
    }
    
    init(
        id: UUID = UUID(),
        name: String = "",
        type: ExerciseType,
        intencity: ExerciseIntencity? = nil,
        duration: Int,
        caloriesPerMinute: String,
        condition: ExerciseCondition? = nil
    ) {
        self.id = id
        self.name = name 
        self.type = type
        self.intencity = intencity
        self.duration = duration
        self.caloriesPerMinute = caloriesPerMinute
    }
    
    init(isMock: Bool, type: ExerciseType? = nil) {
        self.id = .init()
        self.name = isMock ? "Custom Exercise" : ""
        self.type = type ?? .custom
        self.intencity = isMock ? .medium : nil
        self.duration = 30
        self.caloriesPerMinute = type == nil ? (isMock ? "10" : "") : String(type?.caloriesPerMinute ?? 0)
        self.condition = .normal
    }
}
