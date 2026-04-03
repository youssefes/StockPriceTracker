//
//  SocketManager.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation
import Combine

final class SocketClient: NSObject, WebSocketContract {
    
    // MARK: - Private Properties

    /// The current active WebSocket task.
    private var webSocketTask: URLSessionWebSocketTask?
    
    /// The URLSession used to manage the WebSocket connection.
    private var session: URLSession?
    
    /// The original request used to initiate the WebSocket connection.
    private var request: URLRequest?
    
    /// Flag to indicate if the disconnect was triggered manually.
    private var isManuallyDisconnected = false
    
    /// Flag to indicate if the WebSocket is currently connected.
    private var isConnected = false

    // MARK: - Combine Publishers

    /// Publisher that emits when the WebSocket connection is successfully established.
    var onConnected = PassthroughSubject<Void, Never>()
    
    /// Publisher that emits when a message is received from the WebSocket.
    var onReceiveMessage = PassthroughSubject<Data, Never>()
    
    /// Publisher that emits when authorization fails (e.g., code 4403).
    var onAuthorizationFailed = PassthroughSubject<String, Never>()
    
    /// Publisher that emits when the WebSocket is disconnected.
    var onDisconnected = PassthroughSubject<Void, Never>()
    
    // MARK: - Public Methods

    /// Establishes a WebSocket connection using the given URL request.
    /// - Parameter request: The URLRequest used to open the WebSocket connection.
    func connect(with request: URLRequest) async {
        guard !isConnected else { return }

        self.request = request
        isManuallyDisconnected = false

        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session?.webSocketTask(with: request)
        webSocketTask?.resume()
    }

    /// Closes the WebSocket connection manually.
    func disconnect() {
        isManuallyDisconnected = true
        isConnected = false
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        session = nil
        webSocketTask = nil
    }

    /// Sends a string message over the WebSocket connection.
    /// - Parameter message: The message to send.
    func send(_ message: String) async {
        do {
            try await webSocketTask?.send(.string(message))
        } catch {
            await handleConnectionDrop()
        }
    }

    /// Continuously listens for incoming messages on the WebSocket.
    /// Automatically replies to `PING` messages with `PONG`.
    func receiveMessages() async {
        guard let task = webSocketTask else { return }

        while isConnected {
            do {
                let message = try await task.receive()
                switch message {
                case .string(let text):
                    if text == "PING" {
                        await send("PONG")
                    } else {
                        guard let data = text.data(using: .utf8) else { return }
                        onReceiveMessage.send(data)
                    }
                    
                case .data(let data):
                    onReceiveMessage.send(data)
                    
                @unknown default:
                    print("Received unknown message")
                }
            } catch {
                await handleConnectionDrop()
                break
            }
        }
    }

    // MARK: - Private Helpers

    /// Handles unexpected connection drops and triggers reconnection attempts unless manually disconnected.
    private func handleConnectionDrop() async {
        onDisconnected.send()
        isConnected = false
        guard !isManuallyDisconnected else { return }
        while (!isConnected && !isManuallyDisconnected) {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // Retry after 3 seconds
            if let request = request {
                await connect(with: request)
            }
        }
    }

}

// MARK: - URLSessionWebSocketDelegate

extension SocketClient: URLSessionWebSocketDelegate {

    /// Called when the WebSocket connection is successfully established.
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        isConnected = true
        onConnected.send()
        Task {
            await receiveMessages()
        }
    }

    /// Called when the WebSocket connection is closed.
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        Task {
            await handleConnectionDrop()
        }
    }
}
