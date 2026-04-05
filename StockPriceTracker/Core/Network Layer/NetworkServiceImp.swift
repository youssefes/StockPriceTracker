//
//  NetworkServiceImp.swift
//  StockPriceTracker
//
//  Created by Mader's Macbook Pro on 03/04/2026.
//  Copyright © 2026 youssef. All rights reserved.

import Foundation

// MARK: - Network Service Implementation
final class NetworkServiceImplementation: NetworkService {
    private let baseURL: URL?
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(baseURL: URL? = URL(string: APIUrls.baseDomain),
         session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.baseURL = baseURL
        self.session = session
        self.jsonDecoder = decoder
        self.jsonEncoder = encoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        // Build URL
        guard let baseURL = baseURL else {
            throw NetworkError.invalidURL
        }
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            urlComponents.queryItems = endpoint.queryItems
        }
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        // Build Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        if let body = endpoint.body {
            do {
                request.httpBody = try jsonEncoder.encode(AnyEncodable(body))
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.decodingError(error)
            }
        }

        // Perform Request
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }

            do {
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }

        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
