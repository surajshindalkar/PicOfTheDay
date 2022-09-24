//
//  FavouitesTab.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

/// Displays a list of Favourite pics. Also allows Swipe To Delete featiure to remove a favourite from favourite list
struct FavouritesTab: View {
    
    @StateObject private var viewModel = FavouritesTabViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favourites ?? [], id: \.id) { favourite in
                    NavigationLink {
                        PicOfTheDayView(title: favourite.title,
                                        date: favourite.date,
                                        url: favourite.url,
                                        explanation: favourite.explanation,
                                        isFavourite: true,
                                        mediaType: PicOfTheDay.MediaType(rawValue: favourite.mediaType) ?? .image,  toggleCallback: {
                            viewModel.toggleFavourite(pic: favourite)
                        })
                    } label: {
                        FavouriteListRowView(title: favourite.title,
                                             date: favourite.date,
                                             url: favourite.url)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first, let pic = viewModel.favourites?[index] {
                        viewModel.toggleFavourite(pic: pic)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }
    
}


