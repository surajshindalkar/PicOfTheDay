//
//  NASAPicService.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

/// Service to fetch Pic of The Day data from NASA endpoint
struct NASAPicService {
    static func pic(date: String) async throws -> PicOfTheDay {
        let request = NASARequests.getAstronomyPicOfTheDay(date)
        let result = try await RESTNetworkService.run(request, responseModel: PicOfTheDay.self)
        return result
    }
}
