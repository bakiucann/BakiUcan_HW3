//
//  DictionaryResponse.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import Foundation

struct DictionaryResponse: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]
}

struct Phonetic: Codable {
    let text: String
    let audio: String?
    let sourceUrl: String?
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]

}

struct Definition: Codable {
    let definition: String
    let example: String?
}
