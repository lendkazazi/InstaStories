//
//  StoryListViewModel.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import Combine

@MainActor
final class StoryListViewModel: ObservableObject {
    @Published var storiesWithState: [StoryWithState] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let repository: StoryRepository
    private var currentPage = 1
    private let pageLimit = 20
    private var canLoadMore = true
    
    init(repository: StoryRepository) {
        self.repository = repository
    }
    
    // MARK: - Initial Load
    func loadInitialStories() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        canLoadMore = true
        
        do {
            let stories = try await repository.fetchStories(page: currentPage, limit: pageLimit)
            storiesWithState = await withTaskGroup(of: StoryWithState.self) { group in
                for story in stories {
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
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Pagination
    func loadMoreStoriesIfNeeded(currentStory: StoryWithState) async {
        guard canLoadMore, !isLoading else { return }
        
        // Trigger when we're 5 stories away from the end
        let thresholdIndex = storiesWithState.index(storiesWithState.endIndex, offsetBy: -5)
        if let currentIndex = storiesWithState.firstIndex(where: { $0.id == currentStory.id }),
           currentIndex >= thresholdIndex {
            await loadMoreStories()
        }
    }
    
    private func loadMoreStories() async {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        
        do {
            let newStories = try await repository.fetchStories(page: currentPage, limit: pageLimit)
            
            if newStories.isEmpty {
                canLoadMore = false
            } else {
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
                storiesWithState.append(contentsOf: newStoriesWithState)
                currentPage += 1
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Story State Updates
    func updateStoryState(storyId: String) async {
        if let index = storiesWithState.firstIndex(where: { $0.id == storyId }) {
            let updatedState = await repository.getStoryState(storyId: storyId)
            storiesWithState[index].state = updatedState
        }
    }
    
    func refreshStates() async {
        for index in storiesWithState.indices {
            let storyId = storiesWithState[index].id
            let state = await repository.getStoryState(storyId: storyId)
            storiesWithState[index].state = state
        }
    }
}
