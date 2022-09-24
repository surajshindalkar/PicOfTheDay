//
//  Utilities.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import Foundation

/// Dispatch on main thread, without creating a thread lock
/// - Parameter dispatchBlock: Dispatch block that put on main thread once
func dispatchOnMainThread(dispatchBlock: @escaping () -> Void) {
    if !Thread.isMainThread {
        DispatchQueue.main.async {
            dispatchBlock()
        }
    } else {
        dispatchBlock()
    }
}
