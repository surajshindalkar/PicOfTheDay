//
//  PersistentStoreService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import UIKit
import SwiftUI


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
    
    // Save last updated and favourites on disk
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
        guard let favourites = InMemoryStorageService.shared.storageModel.favourites else { return }
        favourites.forEach { favourite in
            guard
                let image = InMemoryStorageService.shared.getImageData(key: favourite.id)
            else { return }
            saveImage(id: favourite.id, imageData: image)
        }
    }
    
}

extension PersistantStoreService {
    
    func saveImage(id: String, imageData: Data) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
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
        
        do {
            try imageData.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }

    func loadImageFromDiskWith(id: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(id)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
}

