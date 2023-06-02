//
//  DictionaryResponse.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation

struct DictionaryResponse: Codable {
    // MARK: - Properties
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]
}

struct Phonetic: Codable {
    // MARK: - Properties
    let text: String?
    let audio: String?
    let sourceUrl: String?
}

struct Meaning: Codable {
    // MARK: - Properties
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    // MARK: - Properties
    let definition: String
    let example: String?
}
