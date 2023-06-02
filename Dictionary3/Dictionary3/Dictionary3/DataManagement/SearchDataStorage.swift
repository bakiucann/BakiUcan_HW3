//
//  File.swift
//  Dictionary3
//
//  Created by Baki Uçan on 2.06.2023.
//

import UIKit
import CoreData

protocol SearchDataStorageProtocol {
    // MARK: - Methods
    func saveSearchTerm(_ term: String)
    func getRecentSearches() -> [String]
}

class SearchDataStorage: SearchDataStorageProtocol {
    // MARK: - Properties
    private let appDelegate: AppDelegate

    // MARK: - Initialization
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    // MARK: - Saving Search Term
    func saveSearchTerm(_ term: String) {
        let context = appDelegate.persistentContainer.viewContext

        let recentSearches = getRecentSearches()

        if !recentSearches.contains(term) {
            let entity = NSEntityDescription.entity(forEntityName: "Search", in: context)!
            let search = NSManagedObject(entity: entity, insertInto: context)
            search.setValue(term, forKey: "term")
            search.setValue(Date(), forKey: "date")
            appDelegate.saveContext()
        }
    }

    // MARK: - Retrieving Recent Searches
    func getRecentSearches() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 5

        do {
            let result = try context.fetch(fetchRequest)
            let recentSearches = result.compactMap({ $0.term })
            return recentSearches
        } catch {
            print("Error fetching recent searches: \(error)")
            return []
        }
    }
}
