//
//  InMemoryStorageService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import UIKit

/// This singleton service is kind of NSManagedObjectContext in Core data. It loads last updated and favourites on its initialisation and and keeps updated this data. PersistentStorageService data from this service while saving data on disk when app enters background
class InMemoryStorageService {
    
    static let shared = InMemoryStorageService()
    
    var storageModel: InMemoryStorageModel
    
    init() {
        let lastUpdated = PersistantStoreService.shared.getLastUpdated()
        let favourites = PersistantStoreService.shared.getFavourites()
        storageModel = InMemoryStorageModel(lastUpdated: lastUpdated,
                                      favourites: favourites)
        
        NotificationCenter.default
                    .addObserver(self, selector: #selector(self.clearCache), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
    
    // Remove In Memory Image Cache while going to background, otherwise Memory will keep increasing significantly if app is not killed for a long time as these images are heavy
    @objc private func clearCache() {
        storageModel.imageCache.removeAll()
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
