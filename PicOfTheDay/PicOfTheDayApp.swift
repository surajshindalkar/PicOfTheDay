//
//  PicOfTheDayApp.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import SwiftUI

/* This method should not be called on the main thread - This is happening beacasue of WebView but as of now, there is no solution for this. https://developer.apple.com/forums/thread/712074
 */

@main
struct PicOfTheDayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
