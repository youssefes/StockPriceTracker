//
//  StockListView.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import SwiftUI

struct StockListView: View {
    @StateObject var viewModel = StockListViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await viewModel.lisentToStockList()
        }
    }
}

#Preview {
    StockListView()
}
