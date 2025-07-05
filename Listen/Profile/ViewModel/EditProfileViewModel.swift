import Foundation
import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var bio: String
    @Published var memberSince: Date
    @Published var preferredWritingTime: UserProfile.WritingTime
    @Published var dailyReminders: Bool
    @Published var avatarImage: UIImage?
    var onSave: ((String, String, String, Date, UserProfile.WritingTime, Bool, UIImage?) -> Void)?
    
    init(name: String, email: String, bio: String, memberSince: Date, preferredWritingTime: UserProfile.WritingTime, dailyReminders: Bool, avatarImage: UIImage?, onSave: ((String, String, String, Date, UserProfile.WritingTime, Bool, UIImage?) -> Void)? = nil) {
        self.name = name
        self.email = email
        self.bio = bio
        self.memberSince = memberSince
        self.preferredWritingTime = preferredWritingTime
        self.dailyReminders = dailyReminders
        self.avatarImage = avatarImage
        self.onSave = onSave
    }
    
    func changePhoto() {
        // Handle photo change
    }
    func saveChanges() {
        onSave?(name, email, bio, memberSince, preferredWritingTime, dailyReminders, avatarImage)
    }
} 
