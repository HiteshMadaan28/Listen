import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    // User Info
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var bio: String = ""
    @Published var memberSince: Date = Date()
    @Published var preferredWritingTime: UserProfile.WritingTime = .evening
    @Published var dailyReminders: Bool = true
    @Published var totalEntries: Int = 0
    @Published var todaysEntry: Int = 0
    @Published var streakDays: Int = 0
    @Published var avatarImage: UIImage? = nil {
        didSet {
            UserProfile.saveAvatar(avatarImage)
        }
    }
    
    // App Settings (stubbed for now)
    @Published var appLockType: String = "Face ID"
    @Published var reminderTime: String = "9:00 PM"
    @Published var theme: String = "Light"
    @Published var fontSize: String = "Medium"
    @Published var iCloudSync: Bool = true
    @Published var appVersion: String = "v1.2.0"
    
    private var cancellables = Set<AnyCancellable>()
    private let diaryViewModel: DiaryViewModel
    
    // Init
    init(diaryViewModel: DiaryViewModel) {
        self.diaryViewModel = diaryViewModel
        if let profile = UserProfile.load() {
            update(from: profile)
        }
        avatarImage = UserProfile.loadAvatar()
        // Observe diary entries and update stats
        diaryViewModel.$entries
            .sink { [weak self] _ in
                self?.updateStatsFromEntries()
            }
            .store(in: &cancellables)
        // Initial calculation
        updateStatsFromEntries()
    }
    
    func update(from profile: UserProfile) {
        name = profile.name
        email = profile.email
        bio = profile.bio
        memberSince = profile.memberSince
        preferredWritingTime = profile.preferredWritingTime
        dailyReminders = profile.dailyReminders
        // totalEntries, todaysEntry, streakDays are dynamic
        avatarImage = UserProfile.loadAvatar()
    }
    
    func toUserProfile() -> UserProfile {
        UserProfile(
            name: name,
            email: email,
            bio: bio,
            memberSince: memberSince,
            preferredWritingTime: preferredWritingTime,
            dailyReminders: dailyReminders,
            totalEntries: totalEntries,
            todaysEntry: todaysEntry,
            streakDays: streakDays
        )
    }
    
    func save() {
        let profile = toUserProfile()
        profile.save()
        UserProfile.saveAvatar(avatarImage)
    }
    
    func updateAvatar(_ image: UIImage?) {
        avatarImage = image
        UserProfile.saveAvatar(image)
    }
    
    private func updateStatsFromEntries() {
        let entries = diaryViewModel.entries
        totalEntries = entries.count
        todaysEntry = entries.filter { Calendar.current.isDateInToday($0.date) }.count
        // Streak calculation
        let calendar = Calendar.current
        let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.date) })
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())
        while uniqueDays.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else { break }
            currentDay = previousDay
        }
        streakDays = streak
        // Save updated stats
        save()
    }
} 
