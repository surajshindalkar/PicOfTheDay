//
//  PersistentStorageServiceTests.swift
//  PicOfTheDayTests
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import XCTest
@testable import PicOfTheDay

final class PersistentStorageServiceTests: XCTestCase {

    let service = PersistantStoreService.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        InMemoryStorageService.shared.storageModel.favourites = PicOfTheDay.getMockForFavourites()
        
        service.save()
    }
    
    func testSharedInstance() throws {
        XCTAssertNotNil(PersistantStoreService.shared)
    }

    func testGetLastUpdated() {
        service.saveLastUpdated(pic: PicOfTheDay.getMock())
        let lastUpdated = service.getLastUpdated()
        XCTAssertEqual(lastUpdated?.id, PicOfTheDay.getMock().id)
    }
    
    func testGetFavourites() {
        let favourites = service.getFavourites()
        XCTAssertEqual(favourites.count, InMemoryStorageService.shared.storageModel.favourites?.count)

    }
    
    func testSaveAndLoadImageToAndFromDisk() async throws {
         let _ = try await ImageLoaderService.loadUrlImage(url: URL(string: "https://apod.nasa.gov/apod/image/2209/NeptuneTriton_webb1059.png")!,
                                                            cacheKey: "2022-09-23")
        service.saveImage(id: "2022-09-23", imageData: InMemoryStorageService.shared.storageModel.imageCache["2022-09-23"]!)
        let fechedImage = service.loadImageFromDiskWith(id: "2022-09-23")
        XCTAssertNotNil(fechedImage)
    }

}
