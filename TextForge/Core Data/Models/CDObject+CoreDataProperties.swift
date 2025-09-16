//
// CDObject+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDObject> {
        NSFetchRequest<CDObject>(entityName: "CDObject")
    }

    @NSManaged var title: String
    @NSManaged var id: UUID
    @NSManaged var order: Int
    @NSManaged var creationDate: Date
}

nonisolated extension CDObject: Identifiable {}
