import UIKit

enum ExerciseType: Identifiable, CaseIterable, Codable {
    case yoga
    case run
    case swimming
    case cycling
    case walk
    case custom
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .yoga:
                "Yoga"
            case .run:
                "Run"
            case .swimming:
                "Swimming"
            case .cycling:
                "Cycling"
            case .walk:
                "Walk"
            case .custom:
                "Custom"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .yoga:
                    .Images.Excercise.yoga
            case .run:
                    .Images.Excercise.run
            case .swimming:
                    .Images.Excercise.swimming
            case .cycling:
                    .Images.Excercise.cycling
            case .walk:
                    .Images.Excercise.walk
            case .custom:
                    .Images.Excercise.custom
        }
    }
    
    var caloriesPerMinute: Int? {
        switch self {
            case .yoga:
                4
            case .run:
                10
            case .swimming:
                11
            case .cycling:
                9
            case .walk:
                5
            case .custom:
                nil
        }
    }
}



