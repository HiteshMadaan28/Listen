import SwiftUI

struct DiaryEditEntryView: View {
    @Binding var entry: DiaryEntry
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var content: String
    
    init(entry: Binding<DiaryEntry>, viewModel: DiaryViewModel) {
        self._entry = entry
        self.viewModel = viewModel
        _title = State(initialValue: entry.wrappedValue.title)
        _content = State(initialValue: entry.wrappedValue.content)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Update the entry directly through the binding
                        entry.title = title
                        entry.content = content
                        entry.date = Date()
                        dismiss()
                    }.disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

struct DiaryEditEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AppCoordinator().sharedDiaryViewModel
        let sampleEntry = DiaryEntry(title: "Sample", content: "Sample content")
        return DiaryEditEntryView(entry: .constant(sampleEntry), viewModel: vm)
    }
} 