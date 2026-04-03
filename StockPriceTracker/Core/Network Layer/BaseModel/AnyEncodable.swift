//
//  AnyEncodable.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation

// MARK: - Helper to Encode Any Encodable
struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self.encodeClosure = value.encode(to:)
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
