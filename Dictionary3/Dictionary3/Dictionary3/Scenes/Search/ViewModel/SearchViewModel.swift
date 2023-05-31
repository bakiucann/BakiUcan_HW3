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
    private let searchManager: SearchManager

    init(apiService: APIService = APIService(), searchManager: SearchManager = SearchManager()) {
        self.apiService = apiService
        self.searchManager = searchManager
    }

    func getRecentSearches() -> [String] {
        return searchManager.getRecentSearches()
    }

    func addSearchTerm(_ term: String) {
        searchManager.addSearchTerm(term)
    }

    func getSearchHistoryCount() -> Int {
        return searchManager.getRecentSearches().count
    }

    func getSearchTerm(at index: Int) -> String {
        return searchManager.getRecentSearches()[index]
    }
}
