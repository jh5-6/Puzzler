//
//  RecentSearchTags+CoreDataProperties.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2022/01/15.
//
//

import Foundation
import CoreData


extension RecentSearchTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearchTags> {
        return NSFetchRequest<RecentSearchTags>(entityName: "RecentSearchTags")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension RecentSearchTags : Identifiable {

}
