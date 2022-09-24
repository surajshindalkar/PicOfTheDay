//
//  HomeTabViewModel.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/22/22.
//

import Foundation
import Combine

/// ViewModel for fetching Pic of The Day data required to drive PicofTheView. This viewModel also registers itself to observe changes from  FavouritesService so that it can update itself  with respect changes in Favourites anywhere into the app e.g. in Favourites tab
class PicOfTheDayViewModel: ObservableObject {
    
    @Published var requestState: RequestState<PicOfTheDay> = .loading
    @Published var date = Date()
    
    @Published private var favouritePics: [PicOfTheDay]?

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
        
        dispatchOnMainThread { [weak self] in
            self?.requestState = .loading
        }

        Task {
            do {
                if let pic = try await PicOfTheDayService().fetchPicOfTheDay(date: dateFormatter.string(from: date)) {
                    dispatchOnMainThread { [weak self] in
                        self?.requestState = .success(pic)
                    }
                } else {
                    dispatchOnMainThread { [weak self] in
                        self?.requestState = .failure(PersistentStorageFailure.noDataInPersistentStore)
                    }
                }
            } catch {
                dispatchOnMainThread { [weak self] in 
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
        return favourites.contains { $0.id == requestState.value?.id }
    }
    
    // Returns mock data needed to show as placeholder for redacted view
    func mockPicForRedactedPlaceholder() -> PicOfTheDay {
        PicOfTheDay.getMock()
    }
    
}
