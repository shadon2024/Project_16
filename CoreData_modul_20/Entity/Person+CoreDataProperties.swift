//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Admin on 24.09.2024.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var birthDay: String?
    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var surName: String?

}
