//
//  SearchManager.swift
//  Dictionary3
//
//  Created by Baki Uçan on 30.05.2023.
//

import UIKit

protocol SearchManagerProtocol {
    // MARK: - Methods
    func addSearchTerm(_ term: String)
    func getRecentSearches() -> [String]
}

class SearchManager: SearchManagerProtocol {
    // MARK: - Properties
    private let searchDataStorage: SearchDataStorageProtocol

    // MARK: - Initialization
    init(searchDataStorage: SearchDataStorageProtocol) {
        self.searchDataStorage = searchDataStorage
    }

    // MARK: - Adding Search Term
    func addSearchTerm(_ term: String) {
        searchDataStorage.saveSearchTerm(term)
    }

    // MARK: - Retrieving Recent Searches
    func getRecentSearches() -> [String] {
        return searchDataStorage.getRecentSearches()
    }
}
