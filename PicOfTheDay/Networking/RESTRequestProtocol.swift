//
//  NASARequests.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

enum RESTRequestError: Error {
    case invalidURL
    case invalidServerResponse
    case decode
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case noInternet
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

protocol RESTRequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var urlParams: [String: String]? { get }
    var requestType: RequestType { get }
}

extension RESTRequestProtocol {
    
    func createURLRequest(authToken: String?) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        if let param = urlParams, !param.isEmpty {
            components.queryItems = param.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url
        else { throw RESTRequestError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if let headers = headers, !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            urlRequest.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let params = params, !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: params)
        }
        return urlRequest
    }
}
