//
//  PicOfTheDay.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/21/22.
//

import Foundation

/// The model we get when we make a service call to NASA's api. Also the same model is used to store data  on hard disk to support offline mode
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
    let mediaType: String
    let title: String
    let url: String
    let thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case mediaType = "media_type"
        case url
        case title
        case thumbnailUrl = "thumbnail_url"
    }
}

extension PicOfTheDay: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: CodingKeys.date)
        explanation = try container.decode(String.self, forKey: CodingKeys.explanation)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        url = try container.decode(String.self, forKey: CodingKeys.url)
        mediaType = try container.decode(String.self, forKey: CodingKeys.mediaType)
        thumbnailUrl = try container.decodeIfPresent(String.self, forKey: CodingKeys.thumbnailUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(explanation, forKey: .explanation)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(url, forKey: CodingKeys.url)
        try container.encode(mediaType, forKey: CodingKeys.mediaType)
        try container.encodeIfPresent(thumbnailUrl, forKey: CodingKeys.thumbnailUrl)
    }
}

extension PicOfTheDay {
    
    static func getMock() -> Self {
        PicOfTheDay(date: "2022-09-23",
                    explanation: "Ringed, ice giant Neptune lies near the center of this sharp near-infrared image from the James Webb Space Telescope. The dim and distant world is the farthest planet from the Sun, about 30 times farther away than planet Earth. But in the stunning Webb view the planet's dark and ghostly appearance is due to atmospheric methane that absorbs infrared light. High altitude clouds that reach above most of Neptune's absorbing methane easily stand out in the image though. Coated with frozen nitrogen, Neptune's largest moon Triton is brighter than Neptune in reflected sunlight and is seen at upper left sporting the Webb's characteristic diffraction spikes. Including Triton, seven of Neptune's 14 known moons can be identified in the field of view. Neptune's faint rings are striking in this new space-based planetary portrait. Details of the complex ring system are seen here for the first time since Neptune was visited by the Voyager 2 spacecraft in August 1989", mediaType: "image",
                        title: "Ringed Ice Giant Neptune",
                    url: "https://apod.nasa.gov/apod/image/2209/NeptuneTriton_webb1059.png", thumbnailUrl: nil)
    }
}
