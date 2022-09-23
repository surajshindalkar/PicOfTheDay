//
//  FavouriteListRowView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/23/22.
//

import Foundation
import SwiftUI

struct FavouriteListRowView: View {
    
    let title: String
    let date: String
    let url: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(title)")
                Text("\(date)")
            }
            
            Spacer()
            
            AsyncImage(width: 100,
                       height: 100,
                       placeholderImage: Image("placeholder"),
                       url: URL(string: url)!)
        }
        
    }
}
