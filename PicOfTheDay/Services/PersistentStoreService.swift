//
//  PersistentStoreService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import UIKit
import SwiftUI

/// This service is responsible for caching data on hard disk. We use this service to support No Internet Connectivity.
class PersistantStoreService {
    
    static let shared = PersistantStoreService()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let favouritesDataSourceURL: URL
    private let lastUpdatedDataSourceURL: URL
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    init() {
        favouritesDataSourceURL = documentsDirectory.appendingPathComponent("Favourites").appendingPathExtension("json")
        lastUpdatedDataSourceURL = documentsDirectory.appendingPathComponent("LastUpdated").appendingPathExtension("json")
        NotificationCenter.default
                    .addObserver(self, selector: #selector(self.save), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default
                    .addObserver(self, selector: #selector(self.save), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    // Save Favourites and favourite images on disk. This save operation is done on every app did enter background event. Saving image to disk is heavy operation. So we are doing this only on app enterered background event instead of each Favourite toggle event
    @objc func save() {
        saveFavouriteObjects()
        saveFavouriteImages()
        clearInMemomyCache()
        deleteNoLongerFavouriteImages()
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
    
    func saveLastUpdated(pic: PicOfTheDay) {
        do {
            let data = try encoder.encode(pic)
            try data.write(to: lastUpdatedDataSourceURL)
        } catch {
            print("Error in encoding \(error.localizedDescription)")
        }
    }
    
    // Need to clear InMemoryCache as this will keep increasing memory if the app is not killed for a long time
    private func clearInMemomyCache() {
        InMemoryStorageService.shared.clearCache()
    }
    
    private func saveFavouriteObjects() {
        guard let favourites = InMemoryStorageService.shared.storageModel.favourites else { return  }
        do {
            let data = try encoder.encode(favourites)
            try data.write(to: favouritesDataSourceURL)
        } catch {
            print("Error in encoding \(error.localizedDescription)")
        }
    }
    
    private func saveFavouriteImages() {
        // Save Favourite images
        guard let favourites = InMemoryStorageService.shared.storageModel.favourites else { return }
        favourites.forEach { favourite in
            guard
                let image = InMemoryStorageService.shared.getImageData(key: favourite.id)
            else { return }
            saveImage(id: favourite.id, imageData: image)
        }
    }
    
    /// Delets images that are no longer favourite. This is  required otherwise App will keep data on images if an image is marked as favourite even when it is marked as UnFavourite later
    private func deleteNoLongerFavouriteImages() {
        let favourites = InMemoryStorageService.shared.storageModel.favourites?.compactMap({$0.id})
        
        let excludeDeleteIDs = (favourites ?? []) + ["Favourites.json"] + ["LastUpdated.json"]
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if !excludeDeleteIDs.contains(fileURL.lastPathComponent) {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch  { print(error) }
    }
}


/// Extension to store and retrieve images from and to Documents directory
extension PersistantStoreService {
    
    func saveImage(id: String, imageData: Data) {
        deleteImageIfExists(id: id)
        let fileName = id
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try imageData.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(id: String) -> UIImage? {
        let fileName = id
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let image = UIImage(contentsOfFile: fileURL.path) {
            return image
        }
        return nil
    }
    
    private func deleteImageIfExists(id: String) {
        let fileName = id
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
    }
    
}
