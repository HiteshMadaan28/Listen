# Listen - Digital Diary App

## Architecture Overview

The application follows a modular MVVM architecture with 5 main modules:

### 📁 Module Structure

```
Listen/
├── Core/                    # Shared components across all modules
│   ├── Models/
│   │   └── DiaryEntry.swift
│   ├── ViewModels/
│   │   ├── AppCoordinator.swift
│   │   └── DiaryViewModel.swift
│   └── Views/
│       └── MainTabView.swift
├── Diary/                   # Diary management module
│   └── Views/
│       ├── DiaryListView.swift
│       ├── DiaryDetailView.swift
│       └── DiaryEditEntryView.swift
├── Calendar/                # Calendar integration module
│   └── Views/
│       └── CalendarView.swift
├── Write/                   # Entry creation module
│   └── Views/
│       └── WriteEntryView.swift
├── Insights/                # Analytics and insights module
│   └── Views/
│       └── InsightsView.swift
└── Profile/                 # User profile and settings module
    └── Views/
        └── ProfileView.swift
```

### 🏗️ Architecture Principles

1. **Separation of Concerns**: Each module has its own Views, ViewModels, and Models
2. **Shared Core**: Common components are in the Core module
3. **MVVM Pattern**: Business logic in ViewModels, UI in Views, data in Models
4. **Coordinator Pattern**: AppCoordinator manages navigation and shared state

### 📱 Modules

#### Core Module
- **Models**: Shared data structures (DiaryEntry)
- **ViewModels**: AppCoordinator, DiaryViewModel
- **Views**: MainTabView (navigation container)

#### Diary Module
- **Views**: DiaryListView, DiaryDetailView, DiaryEditEntryView
- **Features**: View entries, edit entries, delete entries

#### Calendar Module
- **Views**: CalendarView
- **Features**: Browse entries by date, calendar integration

#### Write Module
- **Views**: WriteEntryView
- **Features**: Create new entries with mood tracking

#### Insights Module
- **Views**: InsightsView
- **Features**: Analytics, mood trends, search/filter

#### Profile Module
- **Views**: ProfileView
- **Features**: Settings, app lock, export, customization

### 🔄 Data Flow

1. **AppCoordinator**: Manages tab navigation and shared state
2. **DiaryViewModel**: Handles CRUD operations and persistence
3. **Views**: Display data and handle user interactions
4. **Models**: Define data structures

### 💾 Persistence

- UserDefaults for local storage
- JSON encoding/decoding for data serialization
- Automatic save on data changes

### 🎯 Key Features

- ✅ Create, read, edit, delete diary entries
- ✅ Mood tracking with emojis
- ✅ Calendar integration
- ✅ Local persistence
- ✅ Real-time updates with bindings
- ✅ Modular architecture
- ✅ Coordinator pattern for navigation

### 🚀 Getting Started

1. Build and run the project
2. Navigate between tabs using the bottom tab bar
3. Create entries using the Write tab
4. View and edit entries in the Diary tab
5. Browse entries by date in the Calendar tab

### 🔧 Development

- **SwiftUI**: Modern declarative UI framework
- **MVVM**: Clean separation of concerns
- **Combine**: Reactive programming for data flow
- **UserDefaults**: Simple local persistence 