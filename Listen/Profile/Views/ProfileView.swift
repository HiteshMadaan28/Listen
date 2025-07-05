import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: ProfileViewModel
    
    init() {
        // The actual DiaryViewModel will be injected via .environmentObject in MainTabView
        // We'll use a dummy for preview
        _viewModel = StateObject(wrappedValue: ProfileViewModel(diaryViewModel: DiaryViewModel()))
    }
    
    var body: some View {
        NavigationView {
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
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .padding(.top, 8)
                    
                    // Name & Join Date
                    Text(viewModel.userName)
                        .font(.title3).bold()
                    Text("Writing since \(viewModel.joinDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button("Edit Profile") {
                        viewModel.editProfile()
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
                    ProfileStatView(value: viewModel.entriesToday, label: "Today")
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
                        ProfileRow(icon: "lock.fill", title: "App Lock", detail: viewModel.appLockType, action: viewModel.openAppLock)
                        ProfileRow(icon: "bell.fill", title: "Reminders", detail: viewModel.reminderTime, action: viewModel.openReminders)
                        ProfileRow(icon: "paintbrush.fill", title: "Theme", detail: viewModel.theme, action: viewModel.openTheme)
                        ProfileRow(icon: "textformat.size", title: "Font Size", detail: viewModel.fontSize, action: viewModel.openFontSize)
                        
                        // Data & Backup
                        ProfileSectionHeader(title: "DATA & BACKUP")
                        ProfileToggleRow(icon: "icloud", title: "iCloud Sync", isOn: $viewModel.iCloudSync, action: viewModel.openICloudSync)
                        ProfileRow(icon: "square.and.arrow.up", title: "Export Data", action: viewModel.exportData)
                        ProfileRow(icon: "square.and.arrow.down", title: "Import Data", action: viewModel.importData)
                        
                        // Support
                        ProfileSectionHeader(title: "SUPPORT")
                        ProfileRow(icon: "questionmark.circle", title: "Help & FAQ", action: viewModel.openHelp)
                        ProfileRow(icon: "envelope", title: "Contact Support", action: viewModel.contactSupport)
                        ProfileRow(icon: "star", title: "Rate App", action: viewModel.rateApp)
                        
                        // About
                        ProfileRow(icon: "info.circle", title: "About", detail: viewModel.appVersion, action: viewModel.openAbout)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
                
            }
            .background(Color(.systemBackground))
            .padding(.bottom)
        }
    }
}

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
