//
//  Coler.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation
import SwiftUI

extension DesignSystem {
    enum Colors: String {
        case main = "main"
        var color: Color {
            switch self {
            case .main:
                return Color(self.rawValue)
            }
        }
    }
}
