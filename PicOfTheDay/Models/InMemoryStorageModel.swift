//
//  StorageModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import SwiftUI

class InMemoryStorageModel {
    var lastUpdated: PicOfTheDay?
    var favourites: [PicOfTheDay]?
    var imageCache = [String: Data]()
    var picCache = [String: PicOfTheDay]()

    init(lastUpdated: PicOfTheDay? = nil, favourites: [PicOfTheDay]? = nil) {
        self.lastUpdated = lastUpdated
        self.favourites = favourites
    }
}
