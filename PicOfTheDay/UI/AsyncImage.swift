//
//  AsyncImage.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

/// SwifttUI view for loading image from a URL asynchronously. Also provides optional  caching functionality
struct AsyncImage: View {
    
    @StateObject private var viewModel = AsynImageViewModel()
    
    private let url: URL
    private let width: CGFloat
    private let height: CGFloat
    
    // If provided, fetched image will be cached
    private let cacheKey: String?
    
    private struct Constants {
        static let placeholderImage = "placeholder"
    }
    
    init(width: CGFloat,
         height: CGFloat,
         url: URL,
         cacheKey: String? = nil) {
        self.url = url
        self.width = width
        self.height = height
        self.cacheKey = cacheKey
    }
    
    var body: some View {
        VStack {
            switch viewModel.requestState {
            case .loading:
                loadingView
                
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width, height: height)
                
            case .failure(let error):
                Text("\(error.localizedDescription)")
            }
        }
        .task {
            viewModel.loadImage(url: url, cacheKey: cacheKey)
        }
    }
    
}

extension AsyncImage {
    var loadingView: some View {
        ZStack {
            Image(Constants.placeholderImage)
                .resizable()
            ProgressView()
        }
        .frame(width: width, height: height)
        .redacted(reason: .placeholder)
    }
}
