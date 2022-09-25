//
//  ContentView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase)var scenePhase
    
    private struct Constants {
        static let home = NSLocalizedString("tab.home", comment: "")
        static let favourites = NSLocalizedString("tab.favourites", comment: "")
    }

    var body: some View {
        
        TabView {
            HomeTab()
                .tabItem {
                    Label(Constants.home, systemImage: "list.dash")
                }
            
            FavouritesTab()
            .tabItem {
                Label(Constants.favourites, systemImage: "heart.fill")
            }
        }
        .padding()
    }
}
