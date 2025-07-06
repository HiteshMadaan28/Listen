//
//  Info_Widget.swift
//  Info-Widget
//
//  Created by Hitesh Madaan on 06/07/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DiaryStatsEntry {
        DiaryStatsEntry(
            date: Date(),
            recentEntry: "No entries yet",
            totalEntries: 0,
            todayEntries: 0,
            streakDays: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DiaryStatsEntry) -> ()) {
        let entry = getDiaryStats()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getDiaryStats()
        // Refresh every 2 minutes for immediate updates when new data is saved
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(2 * 60)))
        completion(timeline)
    }
    
    // Handle immediate timeline updates
    func getTimelineForImmediateUpdate(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getDiaryStats()
        // Create timeline with immediate refresh for urgent updates
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(30)))
        completion(timeline)
    }
    
    private func getDiaryStats() -> DiaryStatsEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.LoadUserData")
        
        // Force synchronization to get latest data immediately
        UserDefaults.standard.synchronize()
        sharedDefaults?.synchronize()
        
        // Get diary entries
        let entries = loadDiaryEntries(sharedDefaults)
        let totalEntries = entries.count
        
        // Calculate today's entries
        let today = Calendar.current.startOfDay(for: Date())
        let todayEntries = entries.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
        
        // Calculate streak days
        let streakDays = calculateStreakDays(entries)
        
        // Get recent entry title
        let recentEntry = getRecentEntryTitle(entries)
        
        return DiaryStatsEntry(
            date: Date(),
            recentEntry: recentEntry,
            totalEntries: totalEntries,
            todayEntries: todayEntries,
            streakDays: streakDays
        )
    }
    //user_profile_key
    private func loadDiaryEntries(_ sharedDefaults: UserDefaults?) -> [DiaryEntry] {
        // Try shared container first (for widget access)
        if let sharedDefaults = sharedDefaults, let data = sharedDefaults.data(forKey: "diary_entries_key") {
            do {
                let entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
                return entries.sorted { $0.date > $1.date } // Most recent first
            } catch {
                print("Widget: Failed to decode entries from shared container: \(error)")
            }
        }
        
        // Fallback to standard UserDefaults
        if let data = UserDefaults.standard.data(forKey: "diary_entries_key") {
            do {
                let entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
                return entries.sorted { $0.date > $1.date } // Most recent first
            } catch {
                print("Widget: Failed to decode entries from standard UserDefaults: \(error)")
            }
        }
        
        return []
    }
    
    private func calculateStreakDays(_ entries: [DiaryEntry]) -> Int {
        guard !entries.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.date) })
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())
        
        while uniqueDays.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else { break }
            currentDay = previousDay
        }
        
        return streak
    }
    
    private func getRecentEntryTitle(_ entries: [DiaryEntry]) -> String {
        guard let mostRecentEntry = entries.first else {
            return "No entries yet"
        }
        return mostRecentEntry.title.isEmpty ? "Untitled Entry" : mostRecentEntry.title
    }
}

struct DiaryEntry: Codable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var mood: String
}

struct DiaryStatsEntry: TimelineEntry {
    let date: Date
    let recentEntry: String
    let totalEntries: Int
    let todayEntries: Int
    let streakDays: Int
}

struct Info_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            // Recent Entry
            VStack(alignment: .leading, spacing: 2) {
                Text("Recent Entry")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(entry.recentEntry)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Statistics
            HStack(spacing: 12) {
                StatView(title: "Total", value: "\(entry.totalEntries)")
                StatView(title: "Today", value: "\(entry.todayEntries)")
                StatView(title: "Streak", value: "\(entry.streakDays)")
            }
        }
        .padding(12)
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Info_Widget: Widget {
    let kind: String = "Info_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Info_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Info_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Diary Stats")
        .description("View your diary statistics and recent entries.")
    }
}

#Preview(as: .systemSmall) {
    Info_Widget()
} timeline: {
    DiaryStatsEntry(date: .now, recentEntry: "My first entry", totalEntries: 15, todayEntries: 2, streakDays: 5)
    DiaryStatsEntry(date: .now, recentEntry: "No entries yet", totalEntries: 0, todayEntries: 0, streakDays: 0)
}
