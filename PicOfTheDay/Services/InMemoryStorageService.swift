//
//  InMemoryStorageService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import SwiftUI

class InMemoryStorageService {
    
    static let shared = InMemoryStorageService()
    
    // This model is used to save data on disk as well read data from disk
    var storageModel: InMemoryStorageModel
    
    init() {
        let lastUpdated = PersistantStoreService.shared.getLastUpdated()
        let favourites = PersistantStoreService.shared.getFavourites()
        storageModel = InMemoryStorageModel(lastUpdated: lastUpdated,
                                      favourites: favourites)
    }
    
    func saveLastUpdated(pic: PicOfTheDay) {
        storageModel.lastUpdated = pic
    }
    
    func saveFavourite(pic: PicOfTheDay) {
        guard let favourites = storageModel.favourites else {
           return storageModel.favourites = [pic]
        }
        
        if favourites.contains(where: { favourite in
            favourite.id == pic.id
        }) {
           storageModel.favourites = favourites.filter { $0.id != pic.id }
        } else {
           storageModel.favourites = favourites + [pic]
        }
    }
    
}

extension InMemoryStorageService {
    
    func getPicOfTheDay(id: String) -> PicOfTheDay? {
        return storageModel.picCache[id]
    }
    
    func getImageData(key: String) -> Data? {
        if let imageData = storageModel.imageCache[key] {
            return imageData
        } else {
            return nil
        }
    }
    
    func saveImage(key: String, imageData: Data) {
        storageModel.imageCache[key] = imageData
    }
    
    func savePicOfTheDay(id: String, pic: PicOfTheDay) {
        storageModel.picCache[id] = pic
    }
}
