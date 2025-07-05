import SwiftUI

struct DiaryListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showingEditor = false
    @State private var selectedEntry: DiaryEntry? = nil
    @State private var selectedMood: String = ""
    @State private var showAllEntries = false
    @State private var navigateToWriteEntry = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        Text("My Diary")
                            .font(.title2).bold()
                        Spacer()
                        Button { /* search action */ } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        Button { /* settings action */ } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Today's Entry
                    if let entry = coordinator.sharedDiaryViewModel.entries.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Today")
                                    .font(.headline)
                                Spacer()
                                if !entry.mood.isEmpty {
                                    Text(entry.mood)
                                        .font(.title2)
                                }
                            }
                            Text(entry.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(entry.content.prefix(60) + (entry.content.count > 60 ? "..." : ""))
                                .font(.body)
                                .foregroundColor(.primary)
                            Button("Continue Writing") {
                                selectedEntry = entry
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // New Entry & Calendar Buttons
                    HStack(spacing: 12) {
                        Button(action: { coordinator.selectedTab = 2 }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("New Entry")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        Button(action: { coordinator.selectedTab = 1 }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Calendar")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    
                    // Recent Entries
                    HStack {
                        Text("Recent Entries")
                            .font(.headline)
                        Spacer()
                        Button("View All") { showAllEntries = true }
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        let recentEntries = Array(coordinator.sharedDiaryViewModel.entries.prefix(5))
                        if recentEntries.isEmpty {
                            Text("No recent entries.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(recentEntries, id: \.id) { entry in
                                Button(action: { selectedEntry = entry }) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(entry.date, style: .date)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text(entry.content.prefix(50) + (entry.content.count > 50 ? "..." : ""))
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                        if !entry.mood.isEmpty {
                                            Text(entry.mood)
                                                .font(.title2)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 60)
                }
            }
            .scrollIndicators(.hidden)
            .sheet(item: $selectedEntry) { entry in
                DiaryDetailView(viewModel: coordinator.sharedDiaryViewModel, entryId: entry.id)
            }
            .sheet(isPresented: $showAllEntries) {
                AllEntriesView(viewModel: coordinator.sharedDiaryViewModel, onSelect: { entry in
                    selectedEntry = entry
                    showAllEntries = false
                })
            }
            .overlay(
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { coordinator.selectedTab = 2 }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .foregroundColor(.accentColor)
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            )
        }
    }
}

struct AllEntriesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DiaryViewModel
    var onSelect: (DiaryEntry) -> Void
    
    var body: some View {
        NavigationView {
            List(viewModel.entries) { entry in
                Button(action: { onSelect(entry) }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(entry.content.prefix(50) + (entry.content.count > 50 ? "..." : ""))
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("All Entries")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
} 
