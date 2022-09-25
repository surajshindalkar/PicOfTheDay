//
//  PicDataSource.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/25/22.
//

import Foundation

/// This enum helps us identify the data source for PicOfTheDay
enum PicDataSource {
    case inMemory(PicOfTheDay)
    case persistent(PicOfTheDay)
    case remote(PicOfTheDay)
    
    var currentValue: PicOfTheDay {
        switch self {
        case .inMemory(let pic):
            return pic
        case .persistent(let pic):
            return pic
        case .remote(let pic):
            return pic
        }
    }
    
    var persistent: Bool {
        switch self {
        case .persistent(_):
            return true
        default:
            return false
        }
    }
}
