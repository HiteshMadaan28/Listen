import SwiftUI

struct DiaryDetailView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @State private var showingEdit = false
    let entryId: UUID
    
    var entryBinding: Binding<DiaryEntry>? {
        if let index = viewModel.entries.firstIndex(where: { $0.id == entryId }) {
            return Binding(
                get: { viewModel.entries[index] },
                set: { viewModel.entries[index] = $0 }
            )
        }
        return nil
    }
    
    var entry: DiaryEntry? {
        viewModel.entries.first { $0.id == entryId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let entry = entry {
                Text(entry.title)
                    .font(.largeTitle)
                Text(entry.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                Divider()
                Text(entry.content)
                    .font(.body)
                Spacer()
                Button("Edit") { showingEdit = true }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            } else {
                Text("Entry not found")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .sheet(isPresented: $showingEdit) {
            if let entry = entry, let binding = entryBinding {
                DiaryEditEntryView(entry: binding, viewModel: viewModel)
            }
        }
    }
}

struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AppCoordinator().sharedDiaryViewModel
        let entry = DiaryEntry(title: "Sample", content: "Sample content")
        return DiaryDetailView(viewModel: vm, entryId: entry.id)
    }
} 