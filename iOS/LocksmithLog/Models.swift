import Foundation

struct VisitEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var doorName: String
    var notes: String = ""
    var createdAt: Date = Date()
}
