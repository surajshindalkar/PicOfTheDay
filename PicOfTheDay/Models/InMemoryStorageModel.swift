//
//  StorageModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import SwiftUI

/// This model is used to cache data in memory so that we can improve user experience. This model caches images and NASA API call response so that we do not make those service calls if we have data in cache
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
