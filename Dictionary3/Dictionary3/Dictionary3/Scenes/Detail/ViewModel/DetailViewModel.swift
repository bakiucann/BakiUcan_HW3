//  DetailViewModel.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation
import ObservablePackage

class DetailViewModel {
    private let apiService: APIService

    var meanings: Observable<[Meaning]> = Observable()
    var phoneticText: Observable<String?> = Observable()
    var synonyms: Observable<[String]> = Observable()
    var phoneticAudioURLs: Observable<[String]> = Observable()
    var isFiltering = false

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

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
