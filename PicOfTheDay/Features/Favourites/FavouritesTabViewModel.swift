//
//  FavouritesTabViewModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation

class FavouritesTabViewModel: ObservableObject {
    
    @Published var favourites: [PicOfTheDay]?
    
    init() {
        FavouritesService.shared.fetchFavourites()
        FavouritesService.shared.subject
            .receive(on: RunLoop.main)
            .assign(to: &$favourites)
    }
    
    func toggleFavourite(pic: PicOfTheDay) {
        FavouritesService.shared.toggelFavourite(pic: pic)
    }
}
