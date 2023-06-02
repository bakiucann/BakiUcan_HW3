//
//  SearchViewModel.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation

class SearchViewModel {
    // MARK: - Properties
    private let apiService: APIServiceProtocol
    private let searchDataStorage: SearchDataStorageProtocol

    // MARK: - Initialization
    init(apiService: APIServiceProtocol = APIService(), searchDataStorage: SearchDataStorageProtocol = SearchDataStorage()) {
        self.apiService = apiService
        self.searchDataStorage = searchDataStorage
    }

    // MARK: - Public Methods

    // Get the list of recent searches
    func getRecentSearches() -> [String] {
        return searchDataStorage.getRecentSearches()
    }

    // Add a search term to the recent searches list
    func addSearchTerm(_ term: String) {
        searchDataStorage.saveSearchTerm(term)
    }

    // Get the count of the search history
    func getSearchHistoryCount() -> Int {
        return searchDataStorage.getRecentSearches().count
    }

    // Get the search term at a specific index in the search history
    func getSearchTerm(at index: Int) -> String {
        return searchDataStorage.getRecentSearches()[index]
    }
}
