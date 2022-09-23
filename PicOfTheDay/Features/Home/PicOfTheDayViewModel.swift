//
//  HomeTabViewModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import Combine

class PicOfTheDayViewModel: ObservableObject {
    
    @Published var favouritePics: [PicOfTheDay]?
    @Published var requestState: RequestState<PicOfTheDay> = .loading
    
    @Published var date = Date()
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
    }()
    
    init() {
        FavouritesService.shared.subject
            .receive(on: RunLoop.main)
            .assign(to: &$favouritePics)
    }
    
    func fetchPic() {
        requestState = .loading
        Task {
            do {
                if let pic = try await PicOfTheDayService().fetchPicOfTheDay(date: dateFormatter.string(from: date)) {
                    DispatchQueue.main.async { [weak self] in
                        self?.requestState = .success(pic)
                    }
                } else {
                    self.requestState = .failure(ServiceFailure.noDataAvailable)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in 
                    self?.requestState = .failure(error)
                }
            }
        }
    }
    
    func toggleFavourite(pic: PicOfTheDay) {
        FavouritesService.shared.toggelFavourite(pic: pic)
    }
    
    func isFavourite() -> Bool {
        guard let favourites = favouritePics else { return false }
        return favourites.contains { $0.id == requestState.value?.id}
    }
    
}
