//
//  StoryRepositoryImpl.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

final class StoryRepositoryImpl: StoryRepository {
    private let remoteDataSource: StoryRemoteDataSource
    private let persistenceManager: PersistenceManager
    
    init(
        remoteDataSource: StoryRemoteDataSource,
        persistenceManager: PersistenceManager = .shared
    ) {
        self.remoteDataSource = remoteDataSource
        self.persistenceManager = persistenceManager
    }
    
    // MARK: - Fetch Stories
    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        do {
            return try await remoteDataSource.fetchStories(page: page, limit: limit)
        } catch {
            throw RepositoryError.networkError(error)
        }
    }
    
    // MARK: - Story State Management
    func getStoryState(storyId: String) async -> StoryState {
        if let state = await persistenceManager.getStoryState(storyId: storyId) {
            return state
        }
        return StoryState(storyId: storyId)
    }
    
    func updateStoryState(_ state: StoryState) async throws {
        do {
            try await persistenceManager.saveStoryState(state)
        } catch {
            throw RepositoryError.persistenceError
        }
    }
    
    func markAsSeen(storyId: String) async throws {
        var state = await getStoryState(storyId: storyId)
        state.isSeen = true
        state.lastSeenAt = Date()
        try await updateStoryState(state)
    }
    
    func toggleLike(storyId: String) async throws {
        var state = await getStoryState(storyId: storyId)
        state.isLiked.toggle()
        try await updateStoryState(state)
    }
}
