import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    var name: String
    var age: String
    var weight: String
    var height: String
}
