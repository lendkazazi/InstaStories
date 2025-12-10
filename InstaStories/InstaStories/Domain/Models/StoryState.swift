//
//  StoryState.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

struct StoryState: Codable, Sendable {
    let storyId: String
    var isSeen: Bool
    var isLiked: Bool
    var lastSeenAt: Date?
    
    nonisolated init(storyId: String, isSeen: Bool = false, isLiked: Bool = false, lastSeenAt: Date? = nil) {
        self.storyId = storyId
        self.isSeen = isSeen
        self.isLiked = isLiked
        self.lastSeenAt = lastSeenAt
    }
}
