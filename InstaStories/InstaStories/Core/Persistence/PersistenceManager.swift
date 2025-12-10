//
//  PersistenceManager.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

actor PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private let storyStatesKey = "story_states"
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    // MARK: - Story States
    func saveStoryState(_ state: StoryState) throws {
        var states = try getAllStoryStates()
        states[state.storyId] = state
        
        let data = try encoder.encode(states)
        userDefaults.set(data, forKey: storyStatesKey)
    }
    
    func getStoryState(storyId: String) -> StoryState? {
        guard let states = try? getAllStoryStates() else { return nil }
        return states[storyId]
    }
    
    func getAllStoryStates() throws -> [String: StoryState] {
        guard let data = userDefaults.data(forKey: storyStatesKey) else {
            return [:]
        }
        
        do {
            return try decoder.decode([String: StoryState].self, from: data)
        } catch {
            throw PersistenceError.decodingError(error)
        }
    }
    
    func clearAllStates() {
        userDefaults.removeObject(forKey: storyStatesKey)
    }
    
    // MARK: - Batch Operations
    func saveStoryStates(_ states: [StoryState]) throws {
        var existingStates = try getAllStoryStates()
        
        for state in states {
            existingStates[state.storyId] = state
        }
        
        let data = try encoder.encode(existingStates)
        userDefaults.set(data, forKey: storyStatesKey)
    }
}
