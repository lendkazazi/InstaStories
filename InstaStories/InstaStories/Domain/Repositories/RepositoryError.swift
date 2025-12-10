//
//  RepositoryError.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

enum RepositoryError: LocalizedError {
    case networkError(Error)
    case decodingError
    case persistenceError
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to decode data"
        case .persistenceError:
            return "Failed to save data"
        case .notFound:
            return "Resource not found"
        }
    }
}
