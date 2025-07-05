import Foundation
import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var name: String = "Sarah Johnson"
    @Published var email: String = "sarah.johnson@email.com"
    @Published var bio: String = "Passionate about self-reflection and mindful living. Writing helps me process thoughts and emotions."
    @Published var memberSince: Date = Date()
    @Published var preferredWritingTime: WritingTime = .evening
    @Published var dailyReminders: Bool = true
    @Published var streakCelebrations: Bool = true
    @Published var weeklyInsights: Bool = false
    @Published var appLock: Bool = true
    @Published var iCloudSync: Bool = true
    
    enum WritingTime: String, CaseIterable {
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
    
    func changePhoto() {
        // Handle photo change
    }
    func saveChanges() {
        // Save profile changes
    }
} 
