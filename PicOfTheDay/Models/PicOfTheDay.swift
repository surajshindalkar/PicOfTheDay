//
//  PicOfTheDay.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

struct PicOfTheDay: Identifiable {
    
    enum MediaType: String {
       case image = "image"
       case video = "video"
    }
    
    var id: String {
        date
    }
    
    var type: MediaType? {
        MediaType(rawValue: mediaType)
    }
    
    let date: String
    let explanation: String
    let hdUrl: String
    let mediaType: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdUrl = "hdurl"
        case mediaType = "media_type"
        case url
        case title
    }
}

extension PicOfTheDay: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: CodingKeys.date)
        explanation = try container.decode(String.self, forKey: CodingKeys.explanation)
        hdUrl = try container.decode(String.self, forKey: CodingKeys.hdUrl)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        url = try container.decode(String.self, forKey: CodingKeys.url)
        mediaType = try container.decode(String.self, forKey: CodingKeys.mediaType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(explanation, forKey: .explanation)
        try container.encode(hdUrl, forKey: CodingKeys.hdUrl)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(url, forKey: CodingKeys.url)
        try container.encode(mediaType, forKey: CodingKeys.mediaType)
    }
}
