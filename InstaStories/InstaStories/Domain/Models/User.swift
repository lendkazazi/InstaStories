//
//  User.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

struct User: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let username: String
    let profileImageURL: String
    
    init(id: String, username: String, profileImageURL: String) {
        self.id = id
        self.username = username
        self.profileImageURL = profileImageURL
    }
}

