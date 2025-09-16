//
// CDCheckbox+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDCheckbox {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDCheckbox> {
        NSFetchRequest<CDCheckbox>(entityName: "CDCheckbox")
    }

    @NSManaged var text: String
    @NSManaged var isChecked: Bool
    @NSManaged var defaultValue: Bool
}
