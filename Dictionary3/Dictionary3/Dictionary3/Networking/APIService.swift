//
//  APIService.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(term: String, url: String, responseType: T.Type, completion: @escaping (Result<T, APIServiceError>) -> Void)
}

struct APIService: APIServiceProtocol {
     let definitionURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
     let synonymURL = "https://api.datamuse.com/words?rel_syn="

    func fetchData<T: Decodable>(term: String, url: String, responseType: T.Type, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard !term.isEmpty else {
            completion(.failure(.invalidTerm))
            return
        }

        guard let url = URL(string: url + term) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(responseType, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.parsingError(error)))
            }
        }
        task.resume()
    }
}

enum APIServiceError: Error {
    case invalidTerm
    case invalidURL
    case invalidData
    case networkError(Error)
    case parsingError(Error)
}
