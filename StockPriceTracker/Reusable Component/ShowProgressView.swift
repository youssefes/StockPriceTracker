//  ShowProgressView.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import SwiftUI

struct ShowProgressView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.75)
                .ignoresSafeArea()
        }
        VStack{
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1)
            Spacer()
        }
    }
}
