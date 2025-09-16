//
// CDText+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDText {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDText> {
        NSFetchRequest<CDText>(entityName: "CDText")
    }

    @NSManaged var text: String
    @NSManaged var order: Int
}
