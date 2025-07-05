import Foundation

struct DiaryEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var mood: String
    
    init(id: UUID = UUID(), title: String, content: String, date: Date = Date(), mood: String = "") {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.mood = mood
    }
} 