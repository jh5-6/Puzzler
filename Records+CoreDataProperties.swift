//
//  Records+CoreDataProperties.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2022/01/15.
//
//

import Foundation
import CoreData


extension Records {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Records> {
        return NSFetchRequest<Records>(entityName: "Records")
    }

    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var end_date: Date?
    @NSManaged public var grades_major: String?
    @NSManaged public var grades_total: String?
    @NSManaged public var id: String?
    @NSManaged public var images: [Data]?
    @NSManaged public var keywords: String?
    @NSManaged public var location: String?
    @NSManaged public var major: String?
    @NSManaged public var memo: String?
    @NSManaged public var minor: String?
    @NSManaged public var score: String?
    @NSManaged public var start_date: Date?
    @NSManaged public var title: String?
    @NSManaged public var type: String?

}

extension Records : Identifiable {

}
