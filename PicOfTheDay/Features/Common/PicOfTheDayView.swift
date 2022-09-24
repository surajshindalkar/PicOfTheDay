//
//  PicOfTheDayView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

///View that displays Astronomy of The Day data. This is reusable view and is being used for Favourotes as well
struct PicOfTheDayView: View {
    let title: String
    let date: String
    let url: String
    let explanation: String
    let isFavourite: Bool
    let mediaType: PicOfTheDay.MediaType
    let toggleCallback: () -> Void
    
    private struct Constants {
        static let date =   NSLocalizedString("picOfTheDay.date", value: "%@", comment: "")
        static let title = NSLocalizedString("picOfTheDay.title", value: "%@", comment: "")
        static let explanation = NSLocalizedString("picOfTheDay.explanation", comment: "")
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(format: Constants.date, date))
                        .font(.headline)
                    Text(String(format: Constants.title, title))
                        .font(.headline)
                }
                
                // Image/Video view
                MediaView(mediaType: mediaType,
                          url: url,
                          date: date,
                          toggleCallback: toggleCallback,
                          isFavourite: isFavourite)
                .frame(height: 350)
                
                // Explanation
                Text(Constants.explanation)
                    .font(.headline)
                
                Text("\(explanation)")
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
