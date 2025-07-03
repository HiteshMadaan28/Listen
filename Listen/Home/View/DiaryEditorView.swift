import SwiftUI

struct DiaryEditorView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    
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
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addEntry(title: title, content: content)
                        dismiss()
                    }.disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

struct DiaryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEditorView(viewModel: DiaryViewModel())
    }
} 