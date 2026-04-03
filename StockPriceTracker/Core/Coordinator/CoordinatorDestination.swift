//
//  CoordinatorDestination.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation
import SwiftUI

extension View {
    func CoordinatorDestination() -> some View {
        self.navigationDestination(for: AppScreens.self) { Screen in
            switch Screen {
            case .start:
                ContentView()
            }
        }
    }
}
