//
//  NASARequests.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

enum NASARequests: RESTRequestProtocol {
    
    case getAstronomyPicOfTheDay(_ date: String?)
    
    private struct Constants {
       static let hostUrl = "api.nasa.gov"
       static let date = "date"
       static let apiKeyValue = "pWJdXW7ngrxoGqW51CQQ0JCxSuLnpfqqZczO1jyK"
       static let apiKey = "api_key"
       struct Paths {
          static let picOfTheDayPath = "/planetary/apod"
       }
    }
        
    var host: String {
        Constants.hostUrl
    }
    
    var path: String {
        switch self {
        case .getAstronomyPicOfTheDay:
            return Constants.Paths.picOfTheDayPath
        }
    }
    
    var headers: [String: String]? {
       nil
    }
    
    var params: [String: Any]? {
        nil
    }
    
    var urlParams: [String: String]? {
        switch self {
        case .getAstronomyPicOfTheDay(let date):
            var params = [String: String]()
            params[Constants.apiKey] = Constants.apiKeyValue
            params[Constants.date] = date
            return params
        }
    }
    
    var requestType: RequestType {
        .get
    }
}

