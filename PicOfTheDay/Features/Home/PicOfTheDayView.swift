//
//  PicOfTheDayView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

struct PicOfTheDayView: View {
    
    let title: String
    let date: String
    let url: String
    let explanation: String
    let isFavourite: Bool
    let toggleCallback: () -> Void
    
    var body: some View {
        GeometryReader { reader in
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date: \(date)")
                            .font(.headline)
                        Text("Title: \(title)")
                            .font(.headline)
                    }
                    
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(width: reader.size.width,
                                   height: 200,
                                   placeholderImage: Image("placeholder"),
                                   url: URL(string: url)!,
                                   cacheKey: date)
                        Button {
                            toggleCallback()
                        } label: {
                            FavouriteIndicatorView(isFavourite: isFavourite)
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    Text("Explanation:")
                        .font(.headline)
                    Text("\(explanation)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        
    }
}

