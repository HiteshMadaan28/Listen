import SwiftUI

struct MainTabView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack{
            TabView(selection: $coordinator.selectedTab) {
                DiaryListView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Diary")
                    }
                    .tag(0)
                    .environmentObject(coordinator)
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(1)
                    .environmentObject(coordinator)
                WriteEntryView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Write")
                    }
                    .tag(2)
                    .environmentObject(coordinator)
                InsightsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Insights")
                    }
                    .tag(3)
                    .environmentObject(coordinator)
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(4)
                    .environmentObject(coordinator)
            }
            .environmentObject(coordinator)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 
