import SwiftUI

struct DiaryEditEntryView: View {
    let entry: DiaryEntry
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var content: String
    
    init(entry: DiaryEntry, viewModel: DiaryViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
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
                        viewModel.updateEntry(entry, title: title, content: content)
                        dismiss()
                    }.disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

struct DiaryEditEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiaryViewModel()
        let entry = DiaryEntry(title: "Sample", content: "Sample content")
        return DiaryEditEntryView(entry: entry, viewModel: vm)
    }
} 