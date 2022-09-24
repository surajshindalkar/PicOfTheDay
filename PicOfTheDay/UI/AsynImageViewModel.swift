//
//  AsynImageViewModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import Foundation
import SwiftUI

/// View model for AsyncImage. Responsible for providing image/error to AsynImage
class AsynImageViewModel: ObservableObject {
    
    @Published var requestState: RequestState<Image> = .loading
    
    func loadImage(url: URL, cacheKey: String? = nil) {
        
        requestState = .loading
        
        Task {
            do {
                let image = try await ImageLoaderService.loadUrlImage(url: url, cacheKey: cacheKey)
                
                dispatchOnMainThread { [weak self] in
                    self?.requestState = .success(image)
                }
                
                dispatchOnMainThread { [weak self] in
                    self?.requestState = .success(image)
                }
            } catch {
                dispatchOnMainThread { [weak self] in
                    self?.requestState = .failure(error)
                }
            }
        }
    }
}
