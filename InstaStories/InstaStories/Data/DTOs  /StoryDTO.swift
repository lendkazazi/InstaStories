//
//  StoryDTO.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

struct PicsumImageDTO: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}

extension PicsumImageDTO {
    func toStory() -> Story {
        let user = User(
            id: "user_\(id)",
            username: author,
            profileImageURL: "https://i.pravatar.cc/150?img=\(Int(id) ?? 1)"
        )
        
        return Story(
            id: id,
            user: user,
            imageURL: download_url,
            timestamp: Date().addingTimeInterval(-Double.random(in: 0...86400)) // Random time within last 24h
        )
    }
}
