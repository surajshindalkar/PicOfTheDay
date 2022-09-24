//
//  PicOfTheDayServiceTests.swift
//  PicOfTheDayTests
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import XCTest
@testable import PicOfTheDay

final class PicOfTheDayServiceTests: XCTestCase {
    
    func testPicOfTheDownload_incorrectDateFormat() {
        Task {
            do {
                let pic =  try await PicOfTheDayService().fetchPicOfTheDay(date: "24-09-2022")
                XCTAssertNil(pic)
            }
            catch {
                XCTAssertNotNil(error)
            }
        }
    }
        
    func testPicOfTheDownload_correctDateFormat() async throws {
        let pic = try await PicOfTheDayService().fetchPicOfTheDay(date: "2022-09-24")
        
        XCTAssertNotNil(pic)

    }
}
