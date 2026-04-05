//
//  StockListUseCase.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 04/04/2026.
//


import Combine
import Foundation

// MARK:  -  Stock Repository  -

final class StockListUseCase: StockListUseCaseProtocol {
    
    var onConnected = PassthroughSubject<Void, Never>()
    var onReceiveMessage = PassthroughSubject<[StockModel], Never>()
    var onDisconnected = PassthroughSubject<Void, Never>()
    
    private let stockListRepository: StockListRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    init(stockListRepository: StockListRepositoryProtocol = StockListRepository()) {
        self.stockListRepository = stockListRepository
        setSocketBinding()
    }
    
    private func setSocketBinding() {
        stockListRepository.onConnected
            .map { _ in () }
            .sink { [weak self] in self?.onConnected.send($0) }
            .store(in: &cancellables)
        
        stockListRepository.onReceiveMessage
            .compactMap({ $0 })
            .sink { [weak self] in self?.onReceiveMessage.send($0) }
            .store(in: &cancellables)
        
        stockListRepository.onDisconnected
            .map { _ in () }
            .sink { [weak self] in self?.onDisconnected.send($0) }
            .store(in: &cancellables)
    }
    
    func start() async {
        await stockListRepository.start()
    }
    
    func disconnect() {
        stockListRepository.disconnect()
    }
    
}
