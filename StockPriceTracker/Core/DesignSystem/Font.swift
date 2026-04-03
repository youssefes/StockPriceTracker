//
//  Font.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation

enum AppFont: String {
    case bold = "Gotham-Bold"
    case medium = "Gotham-Medium"
    case light = "Gotham-Light"
    case roundedBold = "GothamRnd-Bold"
    var name: String {
        return self.rawValue
    }
}
