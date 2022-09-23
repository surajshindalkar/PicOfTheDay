//
//  FavouriteIndicatorView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import SwiftUI

struct FavouriteIndicatorView: View {
    let isFavourite: Bool
    
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(isFavourite ? .red: .white)
    }
}
