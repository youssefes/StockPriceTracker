//
//  Untitled.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Combine
import Foundation

typealias WebSocketContract = (
    WebSocketHandlerProtocol & WebSocketWrapperProtocol
)
protocol WebSocketHandlerProtocol {
    func connect(with request: URLRequest) async
    func disconnect()
    func send(_ message: String) async
    func receiveMessages() async
}

protocol WebSocketWrapperProtocol  {
    var onConnected: PassthroughSubject<Void, Never> { get }
    var onReceiveMessage: PassthroughSubject<Data, Never> { get }
    var onDisconnected: PassthroughSubject<Void, Never> { get }
}
