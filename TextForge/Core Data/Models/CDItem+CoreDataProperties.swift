//
// CDItem+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDItem {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDItem> {
        NSFetchRequest<CDItem>(entityName: "CDItem")
    }

    @NSManaged var id: UUID
    @NSManaged var template: CDTemplate?
}

extension CDItem: Identifiable {}
