//
//  SearchManager.swift
//  Dictionary3
//
//  Created by Baki Uçan on 30.05.2023.
//

import UIKit

protocol SearchManagerProtocol {
    func addSearchTerm(_ term: String)
    func getRecentSearches() -> [String]
}

class SearchManager: SearchManagerProtocol {
    private let searchDataStorage: SearchDataStorageProtocol

    init(searchDataStorage: SearchDataStorageProtocol) {
        self.searchDataStorage = searchDataStorage
    }

    func addSearchTerm(_ term: String) {
        searchDataStorage.saveSearchTerm(term)
    }

    func getRecentSearches() -> [String] {
        return searchDataStorage.getRecentSearches()
    }
}
