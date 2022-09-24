//
//  PersistantStoreService+Image.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import Foundation
import UIKit

/// Extension to store and retrieve images from and to Documents directory
extension PersistantStoreService {
    
     func saveImage(id: String, imageData: Data) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = id
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try imageData.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }

    func loadImageFromDiskWith(id: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(id)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
}
