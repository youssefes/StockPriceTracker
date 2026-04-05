//
//  StockModel.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

// MARK: - Stock Model
 
import Foundation
 
struct StockModel: Identifiable, Equatable, Decodable {
    let id: String
    let symbol: String
    let companyName: String
    let description: String
    var currentPrice: Double
    var previousPrice: Double
    var priceChange: Double { currentPrice - previousPrice }
    var priceChangePercent: Double {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
    
    init(
        symbol: String,
        companyName: String,
        description: String,
        currentPrice: Double,
        previousPrice: Double
    ) {
        self.id = symbol
        self.symbol = symbol
        self.companyName = companyName
        self.description = description
        self.currentPrice = currentPrice
        self.previousPrice = previousPrice
    }
}
