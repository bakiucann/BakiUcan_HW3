//
//  APIServiceErrors.swift
//  
//
//  Created by Baki Uçan on 1.06.2023.
//

import Foundation

public enum APIServiceError: Error {
    case invalidTerm
    case invalidURL
    case invalidData
    case networkError(Error)
    case parsingError(Error)
    case unknownError

    public var localizedDescription: String {
        switch self {
        case .invalidTerm:
            return "Geçersiz terim."
        case .invalidURL:
            return "Geçersiz URL."
        case .invalidData:
            return "Geçersiz veri."
        case .networkError(let error):
            return "Ağ hatası: \(error.localizedDescription)"
        case .parsingError(let error):
            return "Ayrıştırma hatası: \(error.localizedDescription)"
        case .unknownError:
            return "Bilinmeyen bir hata oluştu."
        }
    }
}

