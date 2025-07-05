import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var sharedDiaryViewModel = DiaryViewModel()
    // Add more shared state or navigation logic as needed
} 