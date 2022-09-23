//
//  ImageLoader.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import UIKit
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    
    var dataTaskPublisherCancellableToken: AnyCancellable?
    
    var isLoading = false
    
    @Published var image = Image("placeholder")
    
    func loadUrlImage(url: URL, shouldCache: Bool = false, cacheKey: String? = nil) {
        
        guard !isLoading else { return }
        
        isLoading = true
        
        // Check if we have cache in memory
        if let key = cacheKey,
           let imageData = InMemoryStorageService.shared.getImageData(key: key),
           let imageUI = UIImage(data: imageData)  {
            self.isLoading = false
            let image = Image(uiImage: imageUI)
            self.image = image
         } else {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let imageUI = UIImage(data: data) {
                        self.isLoading = false
                        let image = Image(uiImage: imageUI)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                        if let key = cacheKey {
                            InMemoryStorageService.shared.saveImage(key: key,
                                                                    imageData: data)
                        }
                    }
                }
                catch {
                    print("Error in fetching pic\(error.localizedDescription)")
                    let errorCode = (error as NSError).code
                    if errorCode == NSURLErrorNotConnectedToInternet {
                        if let key = cacheKey,
                           let imageData = PersistantStoreService.shared.loadImageFromDiskWith(id: key) {
                            self.isLoading = false
                            let image = Image(uiImage: imageData)
                            self.image = image
                        } else {
                            throw error
                        }
                    } else {
                        throw error
                    }
                }
            }
        }
    }
}
