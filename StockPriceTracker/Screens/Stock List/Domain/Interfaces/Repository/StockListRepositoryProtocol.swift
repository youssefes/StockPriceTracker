//
//  StockListRepositoryProtocol.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Combine
import Foundation

// MARK:  -  Stock Repository  -

protocol StockListRepositoryProtocol {
    var onConnected: PassthroughSubject<Void, Never> { get }
    var onReceiveMessage: PassthroughSubject<[StockModel], Never> { get }
    var onDisconnected: PassthroughSubject<Void, Never> { get }
    func start() async
    func disconnect()
}
