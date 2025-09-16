//
// CDMenuOption+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDMenuOption {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDMenuOption> {
        NSFetchRequest<CDMenuOption>(entityName: "CDMenuOption")
    }

    @NSManaged var id: UUID
    @NSManaged var order: Int
    @NSManaged var text: String
    @NSManaged var menu: CDMenu?
}

nonisolated extension CDMenuOption: Identifiable {}
