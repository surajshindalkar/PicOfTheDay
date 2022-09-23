//
//  FavouitesTab.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

struct FavouritesTab: View {
    
    @StateObject var viewModel = FavouritesTabViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.favourites ?? [], id: \.id) { favourite in
                    NavigationLink {
                        PicOfTheDayView(title: favourite.title,
                                        date: favourite.date,
                                        url: favourite.url,
                                        explanation: favourite.explanation,
                                        isFavourite: true, toggleCallback: {
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


