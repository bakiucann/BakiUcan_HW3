//
//  SearchViewModel.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation
import CoreData

class SearchViewModel {
    private let apiService: APIService
    private let searchDataStorage: SearchDataStorage

    init(apiService: APIService = APIService(), searchDataStorage: SearchDataStorage = SearchDataStorage()) {
        self.apiService = apiService
        self.searchDataStorage = searchDataStorage
    }

    func getRecentSearches() -> [String] {
        return searchDataStorage.getRecentSearches()
    }

    func addSearchTerm(_ term: String) {
        searchDataStorage.saveSearchTerm(term)
    }

    func getSearchHistoryCount() -> Int {
        return searchDataStorage.getRecentSearches().count
    }

    func getSearchTerm(at index: Int) -> String {
        return searchDataStorage.getRecentSearches()[index]
    }
}
