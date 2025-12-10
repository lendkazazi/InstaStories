//
//  StoryViewerViewModel.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class StoryViewerViewModel: ObservableObject {
    @Published var currentStory: StoryWithState
    @Published var isLiked: Bool
    @Published var progress: Double = 0.0
    @Published var allStories: [StoryWithState]
    
    private let repository: StoryRepository
    private var currentIndex: Int
    private var timer: Timer?
    private let storyDuration: TimeInterval = 5.0
    private var isLoadingMore = false
    
    // Pagination
    private var currentPage = 2
    private let pageLimit = 20
    
    var currentStoryIndex: Int { currentIndex }
    var totalStories: Int { allStories.count }
    var canGoNext: Bool { currentIndex < allStories.count - 1 }
    var canGoPrevious: Bool { currentIndex > 0 }
    
    var previousStory: StoryWithState? {
        guard canGoPrevious else { return nil }
        return allStories[currentIndex - 1]
    }
    
    var nextStory: StoryWithState? {
        guard canGoNext else { return nil }
        return allStories[currentIndex + 1]
    }
    
    init(initialStory: StoryWithState, allStories: [StoryWithState], repository: StoryRepository) {
        self.currentStory = initialStory
        self.allStories = allStories
        self.repository = repository
        self.currentIndex = allStories.firstIndex(where: { $0.id == initialStory.id }) ?? 0
        self.isLiked = initialStory.isLiked
    }
    
    // MARK: - Lifecycle
    func startStory() {
        markCurrentAsSeen()
        startTimer()
    }
    
    func pauseStory() {
        stopTimer()
    }
    
    func resumeStory() {
        startTimer()
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        stopTimer()
        progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.progress += 0.05 / self.storyDuration
                
                if self.progress >= 1.0 {
                    self.moveToNext()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Navigation
    func moveToNext() {
        guard canGoNext else {
            stopTimer()
            return
        }
        
        currentIndex += 1
        updateCurrentStory()
        checkAndLoadMoreStories()
    }
    
    func moveToPrevious() {
        guard canGoPrevious else { return }
        
        currentIndex -= 1
        updateCurrentStory()
    }
    
    private func updateCurrentStory() {
        currentStory = allStories[currentIndex]
        isLiked = currentStory.isLiked
        markCurrentAsSeen()
        startTimer()
    }
    
    // MARK: - Pagination
    private func checkAndLoadMoreStories() {
        // Trigger when we're 5 stories away from the end
        let threshold = allStories.count - 5
        
        if currentIndex >= threshold && !isLoadingMore {
            Task {
                await loadMoreStories()
            }
        }
    }
    
    private func loadMoreStories() async {
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        
        do {
            let newStories = try await repository.fetchStories(page: currentPage, limit: pageLimit)
            
            if !newStories.isEmpty {
                let newStoriesWithState = await withTaskGroup(of: StoryWithState.self) { group in
                    for story in newStories {
                        group.addTask {
                            let state = await self.repository.getStoryState(storyId: story.id)
                            return StoryWithState(story: story, state: state)
                        }
                    }
                    
                    var results: [StoryWithState] = []
                    for await result in group {
                        results.append(result)
                    }
                    return results
                }
                
                allStories.append(contentsOf: newStoriesWithState)
                currentPage += 1
            }
        } catch {
            print("Failed to load more stories: \(error)")
        }
        
        isLoadingMore = false
    }
    
    // MARK: - Actions
    func toggleLike() {
        Task {
            isLiked.toggle()
            try? await repository.toggleLike(storyId: currentStory.id)
            
            // Update local state
            if let index = allStories.firstIndex(where: { $0.id == currentStory.id }) {
                allStories[index].state.isLiked = isLiked
            }
        }
    }
    
    private func markCurrentAsSeen() {
        Task {
            try? await repository.markAsSeen(storyId: currentStory.id)
        }
    }
    
    func cleanup() {
        stopTimer()
    }
    
    // MARK: - Tap Gestures
    func handleTap(at location: CGPoint, in size: CGSize) {
        let threshold = size.width / 2
        
        if location.x < threshold {
            // Left side - previous story
            if progress < 0.3 {
                moveToPrevious()
            } else {
                // Restart current story
                startTimer()
            }
        } else {
            // Right side - next story
            moveToNext()
        }
    }
}
