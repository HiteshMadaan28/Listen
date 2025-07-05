import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: ProfileViewModel
    @State private var showEditProfile = false
    
    init() {
        // The actual DiaryViewModel will be injected via .environmentObject in MainTabView
        _viewModel = StateObject(wrappedValue: ProfileViewModel(diaryViewModel: AppCoordinator().sharedDiaryViewModel))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                HStack {
                    Button(action: { coordinator.selectedTab = 0 }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    Spacer()
                    Text("Profile")
                        .font(.headline)
                    Spacer()
                    Button(action: { /* Settings action */ }) {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Avatar
                if let avatarImage = viewModel.avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .padding(.top, 8)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .padding(.top, 8)
                }
                
                // Name & Join Date
                Text(viewModel.name)
                    .font(.title3).bold()
                Text(viewModel.bio)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Writing since \(viewModel.memberSince, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button("Edit Profile") {
                    showEditProfile = true
                }
                .buttonStyle(.bordered)
                .padding(.top, 4)
            }
            .padding(.bottom, 16)
            
            Divider()
            
            // Stats
            HStack {
                ProfileStatView(value: viewModel.totalEntries, label: "Total Entries")
                Spacer()
                ProfileStatView(value: viewModel.todaysEntry, label: "Today")
                Spacer()
                ProfileStatView(value: viewModel.streakDays, label: "Streak Days")
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            Divider()
            
            // Settings & Support List
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App Settings
                    ProfileSectionHeader(title: "APP SETTINGS")
                    ProfileRow(icon: "lock.fill", title: "App Lock", detail: viewModel.appLockType, action: {})
                    ProfileRow(icon: "bell.fill", title: "Reminders", detail: viewModel.reminderTime, action: {})
                    ProfileRow(icon: "paintbrush.fill", title: "Theme", detail: viewModel.theme, action: {})
                    ProfileRow(icon: "textformat.size", title: "Font Size", detail: viewModel.fontSize, action: {})
                    
                    // Data & Backup
                    ProfileSectionHeader(title: "DATA & BACKUP")
                    ProfileToggleRow(icon: "icloud", title: "iCloud Sync", isOn: $viewModel.iCloudSync, action: {})
                    ProfileRow(icon: "square.and.arrow.up", title: "Export Data", action: {})
                    ProfileRow(icon: "square.and.arrow.down", title: "Import Data", action: {})
                    
                    // Support
                    ProfileSectionHeader(title: "SUPPORT")
                    ProfileRow(icon: "questionmark.circle", title: "Help & FAQ", action: {})
                    ProfileRow(icon: "envelope", title: "Contact Support", action: {})
                    ProfileRow(icon: "star", title: "Rate App", action: {})
                    
                    // About
                    ProfileRow(icon: "info.circle", title: "About", detail: viewModel.appVersion, action: {})
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            
        }
        .background(Color(.systemBackground))
        .padding(.bottom)
        .navigationDestination(isPresented: $showEditProfile) {
            EditProfileView(
                viewModel: EditProfileViewModel(
                    name: viewModel.name,
                    email: viewModel.email,
                    bio: viewModel.bio,
                    memberSince: viewModel.memberSince,
                    preferredWritingTime: viewModel.preferredWritingTime,
                    dailyReminders: viewModel.dailyReminders,
                    avatarImage: viewModel.avatarImage,
                    onSave: { name, email, bio, memberSince, preferredWritingTime, dailyReminders, avatarImage in
                        viewModel.name = name
                        viewModel.email = email
                        viewModel.bio = bio
                        viewModel.memberSince = memberSince
                        viewModel.preferredWritingTime = preferredWritingTime
                        viewModel.dailyReminders = dailyReminders
                        viewModel.updateAvatar(avatarImage)
                        viewModel.save()
                    }
                )
            )
        }
    }
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    return df
}()

// MARK: - Subviews

struct ProfileStatView: View {
    let value: Int
    let label: String
    var body: some View {
        VStack {
            Text("\(value)").font(.title2).bold()
            Text(label).font(.caption).foregroundColor(.gray)
        }
    }
}

struct ProfileSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption2)
            .foregroundColor(.gray)
            .padding(.top, 8)
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    var detail: String? = nil
    var action: (() -> Void)? = nil
    var body: some View {
        Button(action: { action?() }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
                if let detail = detail {
                    Text(detail).foregroundColor(.gray).font(.subheadline)
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct ProfileToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    var action: (() -> Void)? = nil
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .onTapGesture { action?() }
        }
        .padding(.vertical, 8)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
