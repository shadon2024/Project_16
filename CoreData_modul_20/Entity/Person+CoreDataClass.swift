//
//  Person+CoreDataClass.swift
//  
//
//  Created by Admin on 24.09.2024.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    
    //вспомогателный инциализатор
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Person"), insertInto: CoreDataManager.instance.context)
    }

}
