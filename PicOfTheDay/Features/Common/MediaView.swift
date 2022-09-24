//
//  MediaView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import SwiftUI

/// Displays image or video and a Favourite button
struct MediaView: View {
    let mediaType: PicOfTheDay.MediaType
    let url: String
    let date: String
    let toggleCallback: () -> Void
    let isFavourite: Bool
    
    var body: some View {
        
        GeometryReader { reader in
            ZStack(alignment: .topTrailing) {
                switch mediaType {
                case .image:
                    AsyncImage(width: reader.size.width,
                               height: 350,
                               url: URL(string: url)!,
                               cacheKey: date)
                case .video:
                    VideoPlayerView(url: url)
                        .frame(height: 350)
                }
                
                Button {
                    toggleCallback()
                } label: {
                    FavouriteIndicatorView(isFavourite: isFavourite)
                        .frame(width: 40, height: 40)
                }
            }
        }
    }
}
