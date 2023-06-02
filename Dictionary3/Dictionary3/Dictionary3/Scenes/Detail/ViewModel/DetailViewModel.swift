//
//  DetailViewModel.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation
import ObservablePackage

class DetailViewModel {
    // MARK: - Properties
    private let apiService: APIService

    var meanings: Observable<[Meaning]> = Observable() // Observable array of meanings
    var phoneticText: Observable<String?> = Observable() // Observable phonetic text
    var synonyms: Observable<[String]> = Observable() // Observable array of synonyms
    var phoneticAudioURLs: Observable<[String]> = Observable() // Observable array of phonetic audio URLs
    var isFiltering = false // Flag indicating whether filtering is applied or not

    // MARK: - Initialization
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    // MARK: - Fetching Details
    func getDetails(for term: String) {
        apiService.fetchData(term: term, url: apiService.definitionURL, responseType: [DictionaryResponse].self) { [weak self] (result) in
            switch result {
            case .success(let response):
                let phoneticAudioURLs = response.first?.phonetics?.compactMap { $0.audio } ?? []
                self?.phoneticAudioURLs.value = phoneticAudioURLs.filter { !$0.isEmpty }
                self?.meanings.value = response.first?.meanings.filter { !$0.definitions.isEmpty }
                self?.phoneticText.value = response.first?.phonetic ?? ""
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }

    // MARK: - Fetching Synonyms
    func getSynonyms(for term: String) {
        apiService.fetchData(term: term, url: apiService.synonymURL, responseType: [SynonymResponse].self) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.synonyms.value = response.prefix(5).compactMap { $0.word }
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }
}
