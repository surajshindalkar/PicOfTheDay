//
//  PicOfTheDayService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation
import Combine
import UIKit

protocol PicOfTheDayServiceProtocol {
    func fetchPicOfTheDay(date: String) async throws -> PicDataSource?
}

/// This is single source of truth for getting PicOfTheDay. This service as an abstraction which uses different data sources depending on  requirements e.g. Service call to NASA API, InMemoryStorageServoce or PersistentStorageService.
struct PicOfTheDayService: PicOfTheDayServiceProtocol {
    
    func fetchPicOfTheDay(date: String) async throws -> PicDataSource?  {
        
        // Check if we have it in memory cache
        if let pic = InMemoryStorageService.shared.getPicOfTheDay(id: date) {
            return PicDataSource.inMemory(pic)
        }
        
        // No data in Cache
        do {
            // Make API Call
            let pic = try await NASAPicService.pic(date: date)
            
            // Store in Persistent Store
            PersistantStoreService.shared.saveLastUpdated(pic: pic)
            
            // Store in In Memory cache so that if same requets is hit, we do not need to make another call
            InMemoryStorageService.shared.savePicOfTheDay(id: date, pic: pic)
            
            return PicDataSource.remote(pic)
            
        } catch {
            
            // Error in API call
            print("Error in fetching pic from API \(error.localizedDescription)")
            
            // Error can be beacause of any reason. We want to support No Internet Connectivity.
            let errorCode = (error as NSError).code
            if errorCode == NSURLErrorNotConnectedToInternet {
                // Check if pic exists in Persistent Storage
                if let pic = PersistantStoreService.shared.getLastUpdated() {
                    return PicDataSource.persistent(pic)
                } else {
                    throw error
                }
            } else {
                // Error is not because of No Internet Connectivity. We can not do much here. Throw API error
                throw error
            }
            
        }
    }
}
