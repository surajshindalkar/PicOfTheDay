//
//  PersistentStoreService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import UIKit
import SwiftUI

/// This service is responsible for caching in hard disk. We use this service to support No Internet Connectivity.
class PersistantStoreService {
    
    static let shared = PersistantStoreService()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let favouritesDataSourceURL: URL
    private let lastUpdatedDataSourceURL: URL

    init() {
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        favouritesDataSourceURL = documentsPath.appendingPathComponent("Favourites").appendingPathExtension("json")
        lastUpdatedDataSourceURL = documentsPath.appendingPathComponent("LastUpdated").appendingPathExtension("json")
        
        NotificationCenter.default
                    .addObserver(self, selector: #selector(self.save), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // Save last updated pic and pic image, favourites and favourite images on disk. This save operation is done on every app did enter background event
    @objc func save() {
        saveLastUpdated()
        saveFavourites()
        saveImages()
    }
    
    func getLastUpdated() -> PicOfTheDay? {
        do {
            let data = try Data(contentsOf: lastUpdatedDataSourceURL)
            return try! decoder.decode(PicOfTheDay.self, from: data)
        } catch {
            print("Error = \(error)")
            return nil
        }
    }
    
    func getFavourites() -> [PicOfTheDay] {
        do {
            let data = try Data(contentsOf: favouritesDataSourceURL)
            return try! decoder.decode([PicOfTheDay].self, from: data)
        } catch {
            print("Error = \(error)")
            return []
        }
    }
    
    private func saveLastUpdated() {
        guard let pic = InMemoryStorageService.shared.storageModel.lastUpdated else { return  }
        do {
            let data = try encoder.encode(pic)
            try data.write(to: lastUpdatedDataSourceURL)
        } catch {
            print("Error in encoding \(error.localizedDescription)")
        }
    }
    
    private func saveFavourites() {
        guard let favourites = InMemoryStorageService.shared.storageModel.favourites else { return  }
        do {
            let data = try encoder.encode(favourites)
            try data.write(to: favouritesDataSourceURL)
        } catch {
            print("Error in encoding \(error.localizedDescription)")
        }
    }
    
    private func saveImages() {
        
        // Save Last Updated Image
        if let lastUpdated = InMemoryStorageService.shared.storageModel.lastUpdated,
           let image = InMemoryStorageService.shared.getImageData(key: lastUpdated.url) {
            saveImage(id: lastUpdated.id, imageData: image)
        }
        
        // Save Favourite images
        guard let favourites = InMemoryStorageService.shared.storageModel.favourites else { return }
        favourites.forEach { favourite in
            guard
                let image = InMemoryStorageService.shared.getImageData(key: favourite.id)
            else { return }
            saveImage(id: favourite.id, imageData: image)
        }
    }
    
}

