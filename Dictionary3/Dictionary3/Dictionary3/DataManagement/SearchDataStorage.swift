//
//  File.swift
//  Dictionary3
//
//  Created by Baki Uçan on 2.06.2023.
//

import UIKit
import CoreData

class SearchDataStorage {
    private let appDelegate: AppDelegate

    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

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

    func getRecentSearches() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 5

        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let recentSearches = result.compactMap({ $0.value(forKey: "term") as? String })
            return recentSearches
        } catch {
            print("Error fetching recent searches: \(error)")
            return []
        }
    }
}
