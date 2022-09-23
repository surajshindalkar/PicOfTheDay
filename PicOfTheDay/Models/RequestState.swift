//
//  RequestState.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation

enum RequestState<T> {
    case loading
    case success(_ data: T)
    case failure(_ error: Error)
}

extension RequestState {
    init(_ value: T?) {
        if let value = value {
            self = .success(value)
        } else {
            self = .loading
        }
    }
}

extension RequestState {
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        default:
            return false
        }
    }
    
    var isFailure: Bool {
        switch self {
        case .failure(_):
            return true
        default:
            return false
        }
    }
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
