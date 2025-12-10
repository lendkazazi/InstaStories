//
//  PersistenceError.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

enum PersistenceError: LocalizedError {
    case encodingError(Error)
    case decodingError(Error)
    case saveError
    
    var errorDescription: String? {
        switch self {
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .saveError:
            return "Failed to save data"
        }
    }
}
