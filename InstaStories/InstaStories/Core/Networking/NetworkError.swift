//
//  NetworkError.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        }
    }
}
