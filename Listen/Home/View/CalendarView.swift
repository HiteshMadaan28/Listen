import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject private var viewModel: DiaryViewModel
    @State private var selectedDate = Date()
    @State private var selectedEntry: DiaryEntry? = nil
    
    init() {
        _viewModel = ObservedObject(wrappedValue: AppCoordinator().sharedDiaryViewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                let entriesForDate = viewModel.entries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                if entriesForDate.isEmpty {
                    Spacer()
                    Text("No entries for this date.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(entriesForDate) { entry in
                        Button(action: { selectedEntry = entry }) {
                            VStack(alignment: .leading) {
                                Text(entry.title).font(.headline)
                                Text(entry.date, style: .time).font(.caption).foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
            .sheet(item: $selectedEntry) { entry in
                DiaryDetailView(entry: entry, viewModel: viewModel)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
} 