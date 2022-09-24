//
//  HomeTab.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

struct HomeTab: View {
    @StateObject private var viewModel = PicOfTheDayViewModel()
    @State private var calendarId = UUID()
    
    private struct Constants {
        static let selectDate = NSLocalizedString("homeTab.selectDate", comment: "")
    }

    var body: some View {
        
        VStack(alignment: .leading) {
            
            datePicker
            
            switch viewModel.requestState {
            case .loading:
                PicOfTheDayView(title: viewModel.mockPicForRedactedPlaceholder().title,
                                date: viewModel.mockPicForRedactedPlaceholder().date,
                                url: viewModel.mockPicForRedactedPlaceholder().url,
                                explanation: viewModel.mockPicForRedactedPlaceholder().explanation,
                                isFavourite: false, mediaType: .image,
                                toggleCallback: {
                })
                .redacted(reason: .placeholder)
                
            case .success(let pic):
                PicOfTheDayView(title: pic.title,
                                date: pic.date,
                                url: pic.url,
                                explanation: pic.explanation,
                                isFavourite: viewModel.isFavourite(),
                                mediaType: PicOfTheDay.MediaType(rawValue: pic.mediaType) ?? .image,
                                toggleCallback: {
                                    viewModel.toggleFavourite(pic: pic)
                                })

            case .failure(let error):
                Spacer()
                Text("Error: \(error.localizedDescription)")
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .task {
            viewModel.fetchPic()
        }
    }
}

extension HomeTab {
    var datePicker: some View {
        DatePicker(selection: $viewModel.date, displayedComponents: .date) {
            Text(Constants.selectDate)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }.fixedSize().frame(maxWidth: .infinity, alignment: .leading)
            .id(calendarId)
            .onChange(of: viewModel.date) { _ in
                calendarId = UUID()
                viewModel.fetchPic()
            }
    }
}
