//
//  StoryRepository.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

protocol StoryRepository {
    func fetchStories(page: Int, limit: Int) async throws -> [Story]
    
    func getStoryState(storyId: String) async -> StoryState
    
    func updateStoryState(_ state: StoryState) async throws
    
    func markAsSeen(storyId: String) async throws
    
    func toggleLike(storyId: String) async throws
}
