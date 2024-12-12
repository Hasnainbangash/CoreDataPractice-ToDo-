//
//  ToDo+CoreDataProperties.swift
//  CoreDataPractice(ToDo)
//
//  Created by Elexoft on 12/12/2024.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var toDoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var isCompleted: Bool

}

extension ToDo : Identifiable {

}
