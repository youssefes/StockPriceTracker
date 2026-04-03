//
//  NetworkError.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation

// MARK: - Network Error
public enum NetworkError: Error,Equatable, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case encodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .statusCode(let code):
            return "Unexpected status code: \(code)"
        case .decodingError(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding failed: \(error.localizedDescription)"
        }
    }
}

extension NetworkError {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.errorDescription == rhs.errorDescription // or compare all fields
    }
}

