//
//  ImageLoaderService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import Foundation
import Combine
import SwiftUI

enum ImageLoadingError: Error {
    case noDataFound
    case decodingError
}

/// Service to fetch images from url. It also provides optional in memory caching mechanism
class ImageLoaderService {
    
    static func loadUrlImage(url: URL, cacheKey: String? = nil) async throws -> Image {
        
        // Check if we have cache in memory
        if let key = cacheKey,
           let imageData = InMemoryStorageService.shared.getImageData(key: key),
           let imageUI = UIImage(data: imageData)  {
            return Image(uiImage: imageUI)
        } else {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let imageUI = UIImage(data: data) {
                    if let key = cacheKey {
                        // Store image in cache
                        InMemoryStorageService.shared.saveImage(key: key,
                                                                imageData: data)
                    }
                    return Image(uiImage: imageUI)
                } else {
                    throw ImageLoadingError.decodingError
                }
            }
            catch {
                
                // Error in API call
                print("Error in fetching pic\(error.localizedDescription)")
                
                // Check if Error is due to No Internet Connecticity
                let errorCode = (error as NSError).code
                if errorCode == NSURLErrorNotConnectedToInternet {
                    if let key = cacheKey,
                       let imageData = PersistantStoreService.shared.loadImageFromDiskWith(id: key) {
                        return Image(uiImage: imageData)
                    } else {
                        // No cached data in Persistent Storage, throw error
                        throw PersistentStorageFailure.noDataInPersistentStore
                    }
                } else {
                    // Error is not due to Internet Connectivity. Throw API error
                    throw error
                }
            }
        }
    }
    
}
