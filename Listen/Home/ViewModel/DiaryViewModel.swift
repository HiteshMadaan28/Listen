import Foundation
import SwiftUI
internal import Combine

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    private let entriesKey = "diary_entries_key"
    
    init() {
        loadEntries()
    }
    
    // MARK: - CRUD Operations
    func addEntry(title: String, content: String, mood: String = "") {
        let entry = DiaryEntry(title: title, content: content, mood: mood)
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: DiaryEntry, title: String, content: String, mood: String = "") {
        if let index = entries.firstIndex(of: entry) {
            entries[index].title = title
            entries[index].content = content
            entries[index].date = Date()
            entries[index].mood = mood
        }
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
    }
    
    // MARK: - Persistence
    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else { return }
        do {
            entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
        } catch {
            print("Failed to load entries: \(error)")
        }
    }
} 
