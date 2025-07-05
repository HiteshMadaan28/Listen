//
//  ListenApp.swift
//  Listen
//
//  Created by Hitesh Madaan on 15/06/25.
//

import SwiftUI

@main
struct ListenApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var userProfile: UserProfile? = UserProfile.load()
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding, let _ = userProfile {
                MainTabView()
            } else {
                OnboardingView { name, email in
                    // Create and save a basic UserProfile
                    let profile = UserProfile(
                        name: name,
                        email: email,
                        bio: "",
                        memberSince: Date(),
                        preferredWritingTime: .evening,
                        dailyReminders: true,
                        totalEntries: 0,
                        todaysEntry: 0,
                        streakDays: 0
                    )
                    profile.save()
                    userProfile = profile
                    hasCompletedOnboarding = true
                }
            }
        }
    }
}
