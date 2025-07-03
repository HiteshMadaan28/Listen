import Foundation
import SwiftUI
internal import Combine

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    
    // MARK: - CRUD Operations
    func addEntry(title: String, content: String) {
        let entry = DiaryEntry(title: title, content: content)
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: DiaryEntry, title: String, content: String) {
        if let index = entries.firstIndex(of: entry) {
            entries[index].title = title
            entries[index].content = content
            entries[index].date = Date()
        }
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
    }
} 
