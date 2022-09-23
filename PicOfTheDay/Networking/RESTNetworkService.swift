//
//  RESTNetworkService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

protocol RESTNetworkServiceProtocol {
    static func run<T: Decodable>(_ request: RESTRequestProtocol, authToken: String?, responseModel: T.Type) async throws -> T
}

struct RESTNetworkService: RESTNetworkServiceProtocol {
    
    static func run<T: Decodable>(_ request: RESTRequestProtocol, authToken: String? = nil, responseModel: T.Type) async throws -> T {
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request.createURLRequest(authToken: authToken), delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RESTRequestError.noResponse }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    throw RESTRequestError.decode
                }
                return decodedResponse
            case 401:
                throw RESTRequestError.unauthorized
            default:
                throw RESTRequestError.unexpectedStatusCode(response.statusCode)
            }
        } catch {
            throw error
        }
    }
}
