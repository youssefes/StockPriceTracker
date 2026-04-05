//
//  StockListRepository.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Combine
import Foundation

// MARK:  -  Stock Repository  -

final class StockListRepository: StockListRepositoryProtocol {
    
    var onConnected = PassthroughSubject<Void, Never>()
    var onReceiveMessage = PassthroughSubject<[StockModel], Never>()
    var onDisconnected = PassthroughSubject<Void, Never>()
    
    private let socketClient: WebSocketContract
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    init(socket: WebSocketContract = SocketClient()) {
        self.socketClient = socket
        setSocketBinding()
    }
    
    private func setSocketBinding() {
        socketClient.onConnected
            .map { _ in () }
            .sink { [weak self] in self?.onConnected.send($0) }
            .store(in: &cancellables)
        
        socketClient.onReceiveMessage
            .compactMap({ $0 })
            .sink { [weak self] data in
                do {
                    let messageReq = try JSONDecoder().decode([StockModel].self, from: data)
                    self?.onReceiveMessage.send(messageReq)
                } catch { }
            }
            .store(in: &cancellables)
        
        socketClient.onDisconnected
            .map { _ in () }
            .sink { [weak self] in self?.onDisconnected.send($0) }
            .store(in: &cancellables)
    }
    
    func start() async {
        guard let url = URL(string: APIUrls.stockSymbolsLink) else { return }
        let requestURL = URLRequest(url: url)
        await socketClient.connect(with: requestURL)
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
    
}
