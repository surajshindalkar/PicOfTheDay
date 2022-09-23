//
//  PicOfTheDayService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation
import Combine
import UIKit


enum ServiceFailure: Error {
    case noDataAvailable
}

final class PicOfTheDayService {
    
    func fetchPicOfTheDay(date: String) async throws -> PicOfTheDay?  {
        
        // Check if we have it in memory cache
        if let pic = InMemoryStorageService.shared.getPicOfTheDay(id: date) {
            return pic
        }
        
        do {
            let pic = try await NASAPicService.pic(date: date)
            InMemoryStorageService.shared.saveLastUpdated(pic: pic)
            InMemoryStorageService.shared.savePicOfTheDay(id: date, pic: pic)
            return pic
        } catch {
            
            print("Error in fetching pic\(error.localizedDescription)")
            
            // Offline mode support
            let errorCode = (error as NSError).code
            if errorCode == NSURLErrorNotConnectedToInternet {
                // Check if pic exists in Memory
                if let pic = PersistantStoreService.shared.getLastUpdated() {
                    return pic
                } else {
                    throw error
                }
            } else {
                throw error
            }
            
        }
    }
}
