//
//  HomeTab.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import SwiftUI

struct HomeTab: View {
    
    @StateObject var viewModel = PicOfTheDayViewModel()
    
    @State var calendarId = UUID()

    var body: some View {
        
        VStack {
            DatePicker(
                   "Select Date",
                   selection: $viewModel.date,
                   displayedComponents: [.date]
               )
            .id(calendarId)
            .onChange(of: viewModel.date) { _ in
                calendarId = UUID()
                viewModel.fetchPic()
            }
            
            switch viewModel.requestState {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .success(let pic):
                PicOfTheDayView(title: pic.title,
                                date: pic.date,
                                url: pic.url,
                                explanation: pic.explanation,
                                isFavourite: viewModel.isFavourite(),
                                toggleCallback: {
                    viewModel.toggleFavourite(pic: pic)
                })
            
            case .failure(let error):
                Spacer()
                Text("Error: \(error.localizedDescription)")
                Spacer()
            }
        }
        .padding()
        .task {
            viewModel.fetchPic()
        }
    }
}
