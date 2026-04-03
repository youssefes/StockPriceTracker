//
//  Endpoint.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

// MARK: - HTTP Method
import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - Endpoint

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]
    let body: Encodable?

    init(path: String,
         method: HTTPMethod = .GET,
         headers: [String: String] = [:],
         queryItems: [URLQueryItem] = [],
         body: Encodable? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}
