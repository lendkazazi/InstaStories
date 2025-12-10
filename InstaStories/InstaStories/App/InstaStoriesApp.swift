//
//  InstaStoriesApp.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import SwiftUI
import SwiftData

@main
struct InstaStoriesApp: App {
    private let repository: StoryRepository = {
        let remoteDataSource = PicsumStoryDataSource()
        return StoryRepositoryImpl(remoteDataSource: remoteDataSource)
    }()
    
    var body: some Scene {
        WindowGroup {
            StoryListView(repository: repository)
        }
    }
}
