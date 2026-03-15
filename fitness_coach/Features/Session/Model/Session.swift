import Foundation

struct Session: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    var exercise: Exercise
    let startDate: Date
    let duration: TimeInterval
    var pausedAt: Date?
    var totalPaused: TimeInterval = 0
    var description: String
    
    var endDate: Date {
        startDate
            .addingTimeInterval(duration)
            .addingTimeInterval(totalPaused)
    }
    
    var isPaused: Bool {
        pausedAt != nil
    }
    
    var isFinished: Bool {
        remainingTime() <= 0
    }
    
    init(exercise: Exercise) {
        self.id = UUID()
        self.exercise = exercise
        self.startDate = Date()
        self.duration = TimeInterval(exercise.duration * 60)
        self.description = ""
    }
    
    func remainingTime(now: Date = Date()) -> TimeInterval {
        if let pausedAt {
            return endDate.timeIntervalSince(pausedAt)
        }
        
        return endDate.timeIntervalSince(now)
    }
    
    mutating func pause() {
        guard pausedAt == nil else { return }
        pausedAt = Date()
    }
    
    mutating func resume() {
        guard let pausedAt else { return }
        
        totalPaused += Date().timeIntervalSince(pausedAt)
        self.pausedAt = nil
    }
}
