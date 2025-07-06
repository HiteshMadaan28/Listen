import Foundation
import SwiftUI
import Combine
import WidgetKit

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = [] {
        didSet {
            saveEntries()
            // Notify that entries have changed (for ProfileViewModel)
            NotificationCenter.default.post(name: .diaryEntriesChanged, object: nil)
            // Reload widget timeline when entries change
            reloadWidgetTimeline()
        }
    }
    
    private let entriesKey = "diary_entries_key"
    private let sharedDefaults = UserDefaults(suiteName: "group.com.LoadUserData")
    
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
            // Save to both standard UserDefaults and shared container
            UserDefaults.standard.set(data, forKey: entriesKey)
            sharedDefaults?.set(data, forKey: entriesKey)
            print("DiaryViewModel: Saved \(entries.count) entries to UserDefaults and shared container")
            
            // Test: Save a simple string to verify UserDefaults access
            UserDefaults.standard.set("Test data from main app", forKey: "test_key")
            sharedDefaults?.set("Test data from main app", forKey: "test_key")
            print("DiaryViewModel: Saved test data to UserDefaults and shared container")
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
    
    // MARK: - Widget Timeline Reload
    private func reloadWidgetTimeline() {
        // Check if the widget exists before reloading
        WidgetCenter.shared.getCurrentConfigurations { result in
            guard case .success(let widgets) = result else { 
                print("DiaryViewModel: Failed to get widget configurations")
                return 
            }
            
            // Check if our specific widget exists
            if let widget = widgets.first(where: { $0.kind == "Info_Widget" }) {
                // Reload the specific widget timeline
                WidgetCenter.shared.reloadTimelines(ofKind: "Info_Widget")
                print("DiaryViewModel: Reloaded widget timeline for \(self.entries.count) entries")
            } else {
                // Widget doesn't exist, reload all timelines as fallback
                WidgetCenter.shared.reloadAllTimelines()
                print("DiaryViewModel: Widget not found, reloaded all timelines")
            }
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else { return }
        do {
            entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
            print("DiaryViewModel: Loaded \(entries.count) entries from UserDefaults")
        } catch {
            print("Failed to load entries: \(error)")
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let diaryEntriesChanged = Notification.Name("diaryEntriesChanged")
} 
