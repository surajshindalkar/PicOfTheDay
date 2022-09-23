//
//  AsyncImage.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

struct AsyncImage: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat,
         height: CGFloat,
         placeholderImage: Image,
         url: URL,
         shouldCache: Bool = true,
         cacheKey: String? = nil) {
        self.url = url
        self.width = width
        self.height = height
        imageLoader.loadUrlImage(url: url, cacheKey: cacheKey)
    }
    
    var body: some View {
        imageLoader.image
            .resizable()
            .frame(width: width, height: height)
            .onAppear {
                imageLoader.loadUrlImage(url: self.url)
            }
    }
}
