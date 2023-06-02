//
//  APIServiceErrors.swift
//  
//
//  Created by Baki Uçan on 1.06.2023.
//

import Foundation

public enum APIServiceError: Error {
    // MARK: - Error Cases
    case invalidTerm
    case invalidURL
    case invalidData
    case networkError(Error)
    case parsingError(Error)
    case unknownError

    // MARK: - Localized Description
    public var localizedDescription: String {
        switch self {
        case .invalidTerm:
            return "Invalid term."
        case .invalidURL:
            return "Invalid URL."
        case .invalidData:
            return "Invalid data."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .parsingError(let error):
            return "Parsing error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
