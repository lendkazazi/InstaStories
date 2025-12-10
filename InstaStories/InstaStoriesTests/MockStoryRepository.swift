//
//  MockStoryRepository.swift
//  InstaStoriesTests
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
@testable import InstaStories

final class MockStoryRepository: StoryRepository {
    var fetchStoriesResult: Result<[Story], Error> = .success([])
    var storyStates: [String: StoryState] = [:]
    var shouldThrowError = false
    
    // Track calls
    var fetchStoriesCalled = false
    var markAsSeenCalled = false
    var toggleLikeCalled = false
    var lastFetchedPage: Int?
    var lastFetchedLimit: Int?
    
    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        fetchStoriesCalled = true
        lastFetchedPage = page
        lastFetchedLimit = limit
        
        if shouldThrowError {
            throw RepositoryError.networkError(NSError(domain: "test", code: -1))
        }
        
        switch fetchStoriesResult {
        case .success(let stories):
            return stories
        case .failure(let error):
            throw error
        }
    }
    
    func getStoryState(storyId: String) async -> StoryState {
        return storyStates[storyId] ?? StoryState(storyId: storyId)
    }
    
    func updateStoryState(_ state: StoryState) async throws {
        if shouldThrowError {
            throw RepositoryError.persistenceError
        }
        storyStates[state.storyId] = state
    }
    
    func markAsSeen(storyId: String) async throws {
        markAsSeenCalled = true
        var state = await getStoryState(storyId: storyId)
        state.isSeen = true
        state.lastSeenAt = Date()
        try await updateStoryState(state)
    }
    
    func toggleLike(storyId: String) async throws {
        toggleLikeCalled = true
        var state = await getStoryState(storyId: storyId)
        state.isLiked.toggle()
        try await updateStoryState(state)
    }
}

// MARK: - Test Helpers
extension MockStoryRepository {
    static func makeMockStories(count: Int) -> [Story] {
        (0..<count).map { index in
            Story(
                id: "story_\(index)",
                user: User(
                    id: "user_\(index)",
                    username: "User \(index)",
                    profileImageURL: "https://example.com/profile_\(index).jpg"
                ),
                imageURL: "https://example.com/image_\(index).jpg",
                timestamp: Date()
            )
        }
    }
}
