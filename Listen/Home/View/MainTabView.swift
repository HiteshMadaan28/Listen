import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DiaryListView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Diary")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            WriteEntryView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Write")
                }
            InsightsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Insights")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 