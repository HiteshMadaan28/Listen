import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    // User Info
    @Published var userName: String = "Sarah Johnson"
    @Published var joinDate: String = "January 2024"
    
    // Reference to DiaryViewModel for real data
    @ObservedObject var diaryViewModel: DiaryViewModel
    
    // Computed Stats
    var totalEntries: Int { diaryViewModel.entries.count }
    var entriesToday: Int {
        diaryViewModel.entries.filter { Calendar.current.isDateInToday($0.date) }.count
    }
    var streakDays: Int {
        // Get all unique days with entries
        let calendar = Calendar.current
        let uniqueDays = Set(diaryViewModel.entries.map { calendar.startOfDay(for: $0.date) })
        guard !uniqueDays.isEmpty else { return 0 }
        
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())
        while uniqueDays.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else { break }
            currentDay = previousDay
        }
        return streak
    }
    
    // App Settings
    @Published var appLockType: String = "Face ID"
    @Published var reminderTime: String = "9:00 PM"
    @Published var theme: String = "Light"
    @Published var fontSize: String = "Medium"
    
    // Data & Backup
    @Published var iCloudSync: Bool = true
    
    // About
    @Published var appVersion: String = "v1.2.0"
    
    // Init
    init(diaryViewModel: DiaryViewModel) {
        self.diaryViewModel = diaryViewModel
    }
    
    // Actions (stub implementations)
    func editProfile() {
        // Handle edit profile action
    }
    func openAppLock() {
        // Handle app lock settings
    }
    func openReminders() {
        // Handle reminders settings
    }
    func openTheme() {
        // Handle theme settings
    }
    func openFontSize() {
        // Handle font size settings
    }
    func openICloudSync() {
        // Handle iCloud sync settings
    }
    func exportData() {
        // Handle export data
    }
    func importData() {
        // Handle import data
    }
    func openHelp() {
        // Handle help/FAQ
    }
    func contactSupport() {
        // Handle contact support
    }
    func rateApp() {
        // Handle rate app
    }
    func openAbout() {
        // Handle about
    }
} 
