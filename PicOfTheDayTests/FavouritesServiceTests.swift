//
//  FavouritesServiceTests.swift
//  PicOfTheDayTests
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import XCTest
import Combine
@testable import PicOfTheDay

final class FavouritesServiceTests: XCTestCase {

    let favouriteService = FavouritesService.shared
    let inMemoryService = InMemoryStorageService.shared

    static var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let favourites = PicOfTheDay.getMockForFavourites()
        InMemoryStorageService.shared.storageModel.favourites = favourites
    }

    func testSharedInstance() throws {
        XCTAssertNotNil(FavouritesService.shared)
    }
    
    func testFetchFavourites() {
        favouriteService.fetchFavourites()
        XCTAssertEqual(favouriteService.subject.value?.count, 3)
    }
    
    func testToggleFavourite() {
        let mockTogglePic = PicOfTheDay.getMockForToggleFavourite()
        favouriteService.toggelFavourite(pic: mockTogglePic)
        XCTAssertEqual(favouriteService.subject.value?.count, 2)
    }

}
