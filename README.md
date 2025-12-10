# InstaStories 📱

A production-ready Instagram Stories feature clone built with SwiftUI, Clean Architecture, and modern Swift concurrency.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green.svg)

## 📖 Overview

InstaStories is a fully functional Instagram Stories implementation featuring infinite pagination, gesture-based navigation, persistent state management, and smooth animations. Built as a technical assessment to demonstrate iOS engineering best practices.

## ✨ Features

### Core Functionality
- ✅ **Story List** - Horizontal scrolling feed with visual indicators for seen/unseen stories
- ✅ **Infinite Pagination** - Automatic background loading as users approach the end
- ✅ **Story Viewer** - Full-screen immersive viewing experience
- ✅ **Like/Unlike** - Persistent like state across app sessions
- ✅ **Seen/Unseen States** - Visual differentiation and state persistence
- ✅ **Gesture Support** - Tap, swipe, and long-press interactions

### User Experience
- 🎨 **Instagram-like UI** - Gradient story rings, progress bars, and smooth transitions
- ⚡ **Optimized Performance** - 60fps scrolling with lightweight shimmer effects
- 🔄 **Seamless Loading** - Stories load in background without interrupting user flow
- 📱 **Portrait Only** - Optimized for single-handed mobile use

## 🏗️ Architecture

Built following **Clean Architecture** principles with MVVM pattern:
```
InstaStories/
├── App/
│   └── InstaStoriesApp.swift          # App entry point with DI setup
├── Core/
│   ├── DesignSystem/
│   │   └── DesignSystem.swift         # Design tokens & theme
│   ├── Extensions/
│   │   ├── Shimmer.swift              # Shimmer modifier
│   │   ├── ShimmerPlaceholder.swift   # Shimmer placeholder view
│   │   └── View+Extension.swift       # View extensions
│   ├── Networking/
│   │   ├── NetworkManager.swift       # Actor-based network client
│   │   └── NetworkError.swift         # Network error types
│   └── Persistence/
│       ├── PersistenceManager.swift   # Thread-safe local storage
│       └── PersistenceError.swift     # Persistence error types
├── Domain/
│   ├── Models/
│   │   ├── Story.swift                # Story entity
│   │   ├── StoryState.swift           # Story state entity
│   │   ├── StoryWithState.swift       # Combined state model
│   │   └── User.swift                 # User entity
│   └── Repositories/
│       ├── StoryRepository.swift      # Repository protocol
│       └── RepositoryError.swift      # Repository error types
├── Data/
│   ├── DTOs/
│   │   └── StoryDTO.swift             # API response models
│   ├── DataSources/
│   │   └── StoryRemoteDataSource.swift # Remote data source
│   └── Repositories/
│       └── StoryRepositoryImpl.swift  # Repository implementation
├── Presentation/
│   ├── StoryList/
│   │   ├── ViewModels/
│   │   │   └── StoryListViewModel.swift
│   │   └── Views/
│   │       ├── StoryListView.swift
│   │       ├── StoryListItemView.swift
│   │       └── FeedPostShimmerView.swift
│   └── StoryViewer/
│       ├── ViewModels/
│       │   └── StoryViewerViewModel.swift
│       └── Views/
│           ├── StoryViewerView.swift
│           └── ProgressBarView.swift
└── InstaStoriesTests/
    ├── MockStoryRepository.swift
    ├── StoryRepositoryTests.swift
    └── StoryListViewModelTests.swift
```

## 🛠️ Technical Decisions

### Why Clean Architecture?
- **Separation of Concerns** - Each layer has a single responsibility
- **Testability** - Easy to mock dependencies and test in isolation
- **Maintainability** - Changes in one layer don't affect others
- **Scalability** - New features integrate without refactoring

### Why Lorem Picsum API?
- Free, reliable, and no authentication required
- Perfect for time-boxed technical assessments
- Provides diverse, high-quality images
- Simple pagination support

### Why UserDefaults for Persistence?
- Lightweight and sufficient for simple key-value storage
- No schema migrations needed for story states
- Wrapped in Actor for thread-safety
- Easy to test and mock

### Modern Swift Patterns
- **Async/Await** - All network calls use modern concurrency
- **Actors** - Thread-safe networking and persistence
- **Sendable** - Swift 6 concurrency compliance
- **@MainActor** - Explicit UI thread isolation for ViewModels

## 🧪 Testing

Comprehensive unit test coverage for business logic:
```swift
InstaStoriesTests/
├── MockStoryRepository.swift           # Test doubles
├── StoryRepositoryTests.swift          # Data layer tests
└── StoryListViewModelTests.swift       # Presentation logic tests
```

**Test Coverage:**
- ✅ Pagination logic and edge cases
- ✅ Story state management (seen/liked)
- ✅ Error handling and retry logic
- ✅ Concurrent operations safety
- ✅ Repository pattern implementation

Run tests: `Cmd + U`

## 🎨 Design System

Centralized design tokens ensure consistency:
```swift
// Colors - Semantic naming with dark mode support
DesignSystem.Colors.storyGradientStart
DesignSystem.Colors.textPrimary

// Typography - Scalable type system
DesignSystem.Typography.headline(weight: .semibold)

// Spacing - Consistent layout rhythm
DesignSystem.Spacing.md  // 16pt

// Layout - Reusable dimensions
DesignSystem.Layout.profileImageSmall  // 32pt
```

## 📦 Dependencies

**Zero external dependencies** - Pure SwiftUI implementation.

Data source: [Lorem Picsum API](https://picsum.photos)

## 🚀 Getting Started

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 6.0

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/InstaStories.git
cd InstaStories
```

2. Open in Xcode
```bash
open InstaStories.xcodeproj
```

3. Build and run
```bash
Cmd + R
```

### Running Tests
```bash
Cmd + U
```

## 📱 Usage

### Story List
- Scroll horizontally to browse stories
- **Purple/Pink/Orange gradient** = Unseen story
- **Gray ring** = Already seen
- Tap any story to view

### Story Viewer
- **Tap left side** - Previous story (or restart current if at beginning)
- **Tap right side** - Next story
- **Swipe left/right** - Navigate with animation
- **Long press** - Pause story
- **Heart icon** - Like/unlike story
- **X button** - Close viewer

Stories auto-advance after 5 seconds.

## 🎯 Key Highlights

### Performance Optimizations
- Lightweight shimmer animation (single gradient overlay)
- Image layer separation for smooth swipe gestures
- Lazy loading with pagination threshold
- Actor-based concurrency for thread safety

### Code Quality
- Protocol-oriented design for flexibility
- Dependency injection for testability
- Comprehensive error handling
- Swift 6 strict concurrency mode

### User Experience
- Natural gesture interactions
- Smooth 60fps animations
- Instagram-like visual design
- Seamless infinite scrolling

## 📄 License

This project was built as a technical assessment. All rights reserved.

## 👤 Author

**Lend**
- Lead iOS Engineer with 8+ years of experience
- Specialist in dating apps and SwiftUI architecture

---

**Built in 4 hours as a technical assessment, demonstrating production-ready iOS development practices.**
