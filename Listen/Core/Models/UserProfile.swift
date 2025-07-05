import Foundation

struct UserProfile: Codable, Equatable {
    var name: String
    var email: String
    var bio: String
    var memberSince: Date
    var preferredWritingTime: WritingTime
    var dailyReminders: Bool
    var totalEntries: Int
    var todaysEntry: Int
    var streakDays: Int
    
    enum WritingTime: String, Codable, CaseIterable, Equatable {
        case morning, afternoon, evening, night
        var displayName: String {
            switch self {
            case .morning: return "Morning (6 AM - 12 PM)"
            case .afternoon: return "Afternoon (12 PM - 6 PM)"
            case .evening: return "Evening (6 PM - 12 AM)"
            case .night: return "Night (12 AM - 6 AM)"
            }
        }
    }
    
    // UserDefaults helpers
    private static let userDefaultsKey = "user_profile_key"
    
    static func load() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: UserProfile.userDefaultsKey)
        }
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
} 