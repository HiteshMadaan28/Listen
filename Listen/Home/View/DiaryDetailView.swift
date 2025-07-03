import SwiftUI

struct DiaryDetailView: View {
    let entry: DiaryEntry
    @ObservedObject var viewModel: DiaryViewModel
    @State private var showingEdit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
        }
        .padding()
        .sheet(isPresented: $showingEdit) {
            DiaryEditEntryView(entry: entry, viewModel: viewModel)
        }
    }
}

struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiaryViewModel()
        let entry = DiaryEntry(title: "Sample", content: "Sample content")
        return DiaryDetailView(entry: entry, viewModel: vm)
    }
} 