//
//  Untitled.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

// MARK: - Network Service Protocol

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
}
