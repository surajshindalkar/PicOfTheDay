//
//  ImageLoaderServiceTests.swift
//  PicOfTheDayTests
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import XCTest
@testable import PicOfTheDay

final class ImageLoaderServiceTests: XCTestCase {
    
    func testIfImageIsSavedInInMemoryCache() async throws {
        let _ = try await ImageLoaderService.loadUrlImage(url: URL(string: "https://apod.nasa.gov/apod/image/2209/NeptuneTriton_webb1059.png")!,
                                                           cacheKey: "2022-09-23")
        let imageData = InMemoryStorageService.shared.storageModel.imageCache["2022-09-23"]
       XCTAssertNotNil(imageData)
    }
    
    func testErrorForInvalidURLFetchingImage() {
        
        Task {
            do {
                let _ = try await ImageLoaderService.loadUrlImage(url: URL(string: "https://apod.nasa.gov/apod/image/2209/NeptuneTriton_webb1059.png")!,
                                                                   cacheKey: "2022-09-23")
            } catch {
                XCTAssertNotNil(error)
            }
        }
        
    }
}
