//
//  PicOfTheDay+Mock.swift
//  PicOfTheDayTests
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import Foundation
@testable import PicOfTheDay

extension PicOfTheDay {
    static func getMockForFavourites() -> [PicOfTheDay] {
        let pic1 =  PicOfTheDay(date: "2022-09-23",
                                explanation: "Ringed, ice giant Neptune lies near the center of this sharp near-infrared image from the James Webb Space Telescope",
                                mediaType: "image",
                                title: "Ringed Ice Giant Neptune",
                                url: "https://apod.nasa.gov/apod/image/2209/NeptuneTriton_webb1059.png",
                                thumbnailUrl: nil)
        
        let pic2 = PicOfTheDay(date: "2022-09-24",
                               explanation: "The defining astronomical moment for this September's equinox was on Friday, September 23, 2022 at 01:03 UTC",
                                   mediaType: "image",
                                   title: "September Sunrise Shadows",
                                   url: "https://apod.nasa.gov/apod/image/2209/DSCF4968_PS_Lioce-1024.jpg",
                                    thumbnailUrl: nil)
        
      let pic3 = PicOfTheDay(date: "2022-09-08",
                           explanation: "Fans of our fair planet might recognize the outlines of these cosmic clouds. On the left", mediaType: "image", title: "North America and the Pelican", url: "https://apod.nasa.gov/apod/image/2209/NGC7000_NB_2022_1024.jpg",
                             thumbnailUrl: nil)
        
        return [pic1, pic2, pic3]
    }
    
    static func getMockForToggleFavourite() -> PicOfTheDay {
        let pic2 = PicOfTheDay(date: "2022-09-24",
                               explanation: "The defining astronomical moment for this September's equinox was on Friday, September 23, 2022 at 01:03 UTC",
                                   mediaType: "image",
                                   title: "September Sunrise Shadows",
                                   url: "https://apod.nasa.gov/apod/image/2209/DSCF4968_PS_Lioce-1024.jpg",
                                    thumbnailUrl: nil)
        return pic2
    }
    
}
