//
//  Search+CoreDataProperties.swift
//  
//
//  Created by Baki Uçan on 30.05.2023.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var term: String?

}
