//
//  StockRepositoryProtocol.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 04/04/2026.
//


import Foundation
import Combine
// MARK:  -  Stock Repository  -

protocol StockListUseCaseProtocol {
    var onConnected: PassthroughSubject<Void, Never> { get }
    var onReceiveMessage: PassthroughSubject<[StockModel], Never> { get }
    var onDisconnected: PassthroughSubject<Void, Never> { get }
    func start() async
    func disconnect()
}
