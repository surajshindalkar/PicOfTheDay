//
//  FavouritesService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import Combine

/// Provides status of favourites. It's a single source of truth for Favourites
struct FavouritesService {
    
    static let shared = FavouritesService()
    
    let subject = CurrentValueSubject<[PicOfTheDay]?, Never>([])
    
    func toggelFavourite(pic: PicOfTheDay) {
        InMemoryStorageService.shared.saveFavourite(pic: pic)
        subject.send(InMemoryStorageService.shared.storageModel.favourites)
    }
    
    func fetchFavourites() {
        subject.send(InMemoryStorageService.shared.storageModel.favourites)
    }
}
