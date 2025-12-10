//
//  StoryRemoteDataSource.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

protocol StoryRemoteDataSource {
    func fetchStories(page: Int, limit: Int) async throws -> [Story]
}

final class PicsumStoryDataSource: StoryRemoteDataSource {
    private let networkManager: NetworkManager
    private let baseURL = "https://picsum.photos/v2/list"
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let dtos: [PicsumImageDTO] = try await networkManager.request(url: url)
        return dtos.map { $0.toStory() }
    }
}
