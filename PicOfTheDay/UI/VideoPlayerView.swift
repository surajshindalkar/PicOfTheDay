//
//  VideoPlayerView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import SwiftUI

/// SwiftUI  VideoPlayer() does not support Youtube embedded videos.  This views helps play You tube videos
struct VideoPlayerView: View {
    
    let url: String
    
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if let url = URL(string: url) {
                WebView(url: url) { navigationAction in
                    switch navigationAction {
                    case .didFinish(_, _):
                        isLoading = false
                    default:
                        break
                    }
                }
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
}
