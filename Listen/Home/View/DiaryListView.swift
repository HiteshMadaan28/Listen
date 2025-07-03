import SwiftUI

struct DiaryListView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showingEditor = false
    @State private var selectedEntry: DiaryEntry? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries) { entry in
                    Button(action: { selectedEntry = entry }) {
                        VStack(alignment: .leading) {
                            Text(entry.title).font(.headline)
                            Text(entry.date, style: .date).font(.caption).foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.entries[$0] }.forEach(viewModel.deleteEntry)
                }
            }
            .navigationTitle("My Diary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                DiaryEditorView(viewModel: viewModel)
            }
            .sheet(item: $selectedEntry) { entry in
                DiaryDetailView(entry: entry, viewModel: viewModel)
            }
        }
    }
}

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
} 