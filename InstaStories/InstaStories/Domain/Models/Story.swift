//
//  Story.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

struct Story: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let user: User
    let imageURL: String
    let timestamp: Date
    
    init(id: String, user: User, imageURL: String, timestamp: Date = Date()) {
        self.id = id
        self.user = user
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
}
