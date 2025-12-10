//
//  StoryWithState.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

struct StoryWithState: Identifiable, Sendable {
    let story: Story
    var state: StoryState
    
    var id: String { story.id }
    var isSeen: Bool { state.isSeen }
    var isLiked: Bool { state.isLiked }
    
    nonisolated init(story: Story, state: StoryState) {
        self.story = story
        self.state = state
    }
}
