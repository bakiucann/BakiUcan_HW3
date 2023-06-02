//
//  SearchManager.swift
//  Dictionary3
//
//  Created by Baki Uçan on 30.05.2023.
//

import UIKit

class SearchManager {
    private let searchDataStorage: SearchDataStorage

    init(searchDataStorage: SearchDataStorage) {
        self.searchDataStorage = searchDataStorage
    }

    func addSearchTerm(_ term: String) {
        searchDataStorage.saveSearchTerm(term)
    }

    func getRecentSearches() -> [String] {
        return searchDataStorage.getRecentSearches()
    }
}

