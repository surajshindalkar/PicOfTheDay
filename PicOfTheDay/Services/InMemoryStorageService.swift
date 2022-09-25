//
//  InMemoryStorageService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import UIKit

protocol InMemoryStorageServiceProtocol {
    func saveFavourite(pic: PicOfTheDay)
    func clearCache()
    func getPicOfTheDay(id: String) -> PicOfTheDay?
    func getImageData(key: String) -> Data?
    func saveImage(key: String, imageData: Data)
    func savePicOfTheDay(id: String, pic: PicOfTheDay)
}

/// This singleton service is kind of NSManagedObjectContext in Core data. It loads favourites on its initialisation from PersistentStorageService and and keeps updated its data. PersistentStorageService uses data from this service while saving data on disk when app enters background
struct InMemoryStorageService: InMemoryStorageServiceProtocol {
    
    static let shared = InMemoryStorageService()
    var storageModel: InMemoryStorageModel
    
    init() {
        let favourites = PersistantStoreService.shared.getFavourites()
        storageModel = InMemoryStorageModel(favourites: favourites)
    }
}

extension InMemoryStorageService {
    
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
    
    func clearCache() {
        storageModel.imageCache.removeAll()
        storageModel.picCache.removeAll()
    }

    
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
