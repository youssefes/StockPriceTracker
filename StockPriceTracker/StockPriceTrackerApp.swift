//
//  StockPriceTrackerApp.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//

import SwiftUI

@main
struct StockPriceTrackerApp: App {
    @StateObject var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    struct RootView: View {
        @StateObject private var coordinator = AppCoordinator()
        var body: some View {
            NavigationStack(path: $coordinator.path) {
                StockListView()
                    .CoordinatorDestination()
            }
            .environmentObject(coordinator)
        }
    }
}
