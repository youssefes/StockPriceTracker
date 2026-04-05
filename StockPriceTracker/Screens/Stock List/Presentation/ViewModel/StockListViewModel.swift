//
//  StockListViewModel.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 04/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation
import Combine

class StockListViewModel: BaseViewModel, ObservableObject {
    @Published var stockList: [StockModel] = []
    
    private var stockListUseCase: StockListUseCaseProtocol
    init(stockListUseCase: StockListUseCaseProtocol = StockListUseCase()) {
        self.stockListUseCase = stockListUseCase
    }
    
    func lisentToStockList() async {
        setSocketBinding()
        await stockListUseCase.start()
    }
    
    private func setSocketBinding() {
        stockListUseCase.onReceiveMessage
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] stock in
                guard let self else { return }
                print(stock)
                stockList = stock
            })
            .store(in: &cancellables)
    }
}
