//
//  APIService.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation
import ErrorHandling

protocol APIServiceProtocol {
    // MARK: - Methods
    func fetchData<T: Decodable>(term: String, url: String, responseType: T.Type, completion: @escaping (Result<T, APIServiceError>) -> Void)
}

struct APIService: APIServiceProtocol {
    // MARK: - URL Constants
    let definitionURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    let synonymURL = "https://api.datamuse.com/words?rel_syn="

    // MARK: - Fetch Data
    func fetchData<T: Decodable>(term: String, url: String, responseType: T.Type, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        // Check for empty search term
        guard !term.isEmpty else {
            completion(.failure(APIServiceError.invalidTerm))
            return
        }

        // Create URL from the provided string
        guard let url = URL(string: url + term) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }

        // Perform network request
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIServiceError.networkError(error)))
                return
            }

            // Check for valid response data
            guard let data = data else {
                completion(.failure(APIServiceError.invalidData))
                return
            }

            // Decode the response data
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(responseType, from: data)
                completion(.success(response))
            } catch {
                let parsingError = APIServiceError.parsingError(error)
                completion(.failure(parsingError))
            }
        }
        task.resume()
    }
}
