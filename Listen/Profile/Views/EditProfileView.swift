import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                Spacer()
                Text("Edit Profile")
                    .font(.headline)
                Spacer()
                Button("Save") {
                    viewModel.saveChanges()
                    dismiss()
                }
                .font(.headline)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                                if let avatarImage = viewModel.avatarImage {
                                    Image(uiImage: avatarImage)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                            }
                            .onChange(of: selectedPhoto) { newItem in
                                if let newItem = newItem {
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self),
                                           let uiImage = UIImage(data: data) {
                                            viewModel.avatarImage = uiImage
                                        }
                                    }
                                }
                            }
                            Image(systemName: "camera")
                                .padding(6)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .offset(x: 8, y: 8)
                        }
                       
                    }
                    
                    // Full Name
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Full Name").font(.caption)
                        TextField("Full Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    // Email
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email").font(.caption)
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                    }
                    // Bio
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bio").font(.caption)
                        TextEditor(text: $viewModel.bio)
                            .frame(height: 60)
                            .padding(4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    // Member Since
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Member Since").font(.caption)
                        DatePicker("", selection: $viewModel.memberSince, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    // Preferred Writing Time
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Preferred Writing Time").font(.caption)
                        Picker("Preferred Writing Time", selection: $viewModel.preferredWritingTime) {
                            ForEach(UserProfile.WritingTime.allCases, id: \.self) { time in
                                Text(time.displayName).tag(time)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    // Daily Reminders
                    Toggle(isOn: $viewModel.dailyReminders) {
                        Text("Daily Reminders")
                    }
                    // Save/Cancel Buttons
                    Button(action: {
                        viewModel.saveChanges()
                        dismiss()
                    }) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.label))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}
