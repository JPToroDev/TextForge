//
// CDPlaceholderOrder+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated extension CDPlaceholderOrder {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPlaceholderOrder> {
        return NSFetchRequest<CDPlaceholderOrder>(entityName: "CDPlaceholderOrder")
    }

    @NSManaged var id: UUID
    @NSManaged var order: Int
    @NSManaged var placeholder: CDPlaceholder?
}
