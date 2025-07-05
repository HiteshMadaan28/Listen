import SwiftUI

struct WriteEntryView: View {
    @ObservedObject var viewModel: DiaryViewModel = DiaryViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedMood: String = ""
    @State private var date: Date = Date()
    @State private var showConfirmAlert = false
    
    let moods = ["🥲", "😌", "😐", "😊", "😄"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Date and Change Date
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(date, style: .date)
                                .font(.title3).bold()
                            Text(Calendar.current.isDateInToday(date) ? "Today" : "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Change Date")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(true) // For now, date picker not implemented
                    }
                    .padding(.top)
                    
                    // Mood selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How are you feeling today?")
                            .font(.subheadline)
                        HStack(spacing: 20) {
                            ForEach(moods, id: \.self) { mood in
                                Button(action: { selectedMood = mood }) {
                                    ZStack {
                                        Text(mood)
                                            .font(.system(size: 36))
                                        if selectedMood == mood {
                                            Circle()
                                                .stroke(Color.accentColor, lineWidth: 3)
                                                .frame(width: 44, height: 44)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Title (Optional)")
                            .font(.subheadline)
                        TextField("Give your entry a title...", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your thoughts")
                            .font(.subheadline)
                        TextEditor(text: $content)
                            .frame(height: 180)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if content.isEmpty {
                                        Text("What's on your mind today? Write about your day, feelings, experiences...")
                                            .foregroundColor(.gray)
                                            .padding(12)
                                            .allowsHitTesting(false)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Write Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { coordinator.selectedTab = 0}) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showConfirmAlert = true
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .disabled(content.isEmpty)
                }
            }
            .alert("Confirm Entry", isPresented: $showConfirmAlert) {
                Button("Confirm", role: .destructive) {
                    viewModel.addEntry(title: title, content: content, mood: selectedMood)
                    title = ""
                    content = ""
                    selectedMood = ""
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to save this entry?")
            }
        }
    }
}

struct WriteEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WriteEntryView()
    }
} 
