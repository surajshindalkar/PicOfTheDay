//
//  FavouitesTab.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

/// Displays a list of Favourite pics. Also allows Swipe To Delete feature to remove a favourite item from favourite list
struct FavouritesTab: View {
    
    @StateObject private var viewModel = FavouritesTabViewModel()
    
    private struct Constants {
        static let noFavouritesMessage = NSLocalizedString("noFavourites.message", comment: "")
    }
    
    var body: some View {
        
        HStack {
            if let favourites = viewModel.favourites, favourites.isEmpty {
                Text(Constants.noFavouritesMessage)
            } else {
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
                                if let url = url(favourite: favourite) {
                                    FavouriteListRowView(title: favourite.title,
                                                         date: favourite.date,
                                                         url: url)
                                    .listRowInsets(EdgeInsets())
                                }
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
        .padding(.horizontal, 16)
    }
}

extension FavouritesTab {
    func url(favourite: PicOfTheDay) -> String? {
        if favourite.type == PicOfTheDay.MediaType.image {
            return favourite.url
        } else {
            return favourite.thumbnailUrl
        }
    }
}


