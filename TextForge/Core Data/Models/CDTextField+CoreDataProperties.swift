//
// CDTextField+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDTextField {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDTextField> {
        NSFetchRequest<CDTextField>(entityName: "CDTextField")
    }

    @NSManaged var defaultValue: String
    @NSManaged var text: String
}
