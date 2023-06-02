//
//  SearchViewModel.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation

class SearchViewModel {
    private let apiService: APIServiceProtocol
    private let searchDataStorage: SearchDataStorageProtocol

    init(apiService: APIServiceProtocol = APIService(), searchDataStorage: SearchDataStorageProtocol = SearchDataStorage()) {
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
