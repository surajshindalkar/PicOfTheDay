//
//  ContentView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase)var scenePhase

    var body: some View {
        
        TabView {
            HomeTab()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
            
            FavouritesTab()
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            }else if newPhase == .active {
                print("Active")
            }else if newPhase == .background {
                print("Background")
            }
        }
        .padding()
    }
}
