//
// CDPlaceholder+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDPlaceholder {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDPlaceholder> {
        NSFetchRequest<CDPlaceholder>(entityName: "CDPlaceholder")
    }

    @NSManaged var label: String
    @NSManaged var detail: String?
    @NSManaged var creationDate: Date
    @NSManaged var orders: NSSet?
}

// MARK: Generated accessors for templates

nonisolated public extension CDPlaceholder {
    @objc(addOrdersObject:)
    @NSManaged func addToOrders(_ value: CDPlaceholderOrder)

    @objc(removeOrdersObject:)
    @NSManaged func removeFromOrders(_ value: CDPlaceholderOrder)

    @objc(addOrders:)
    @NSManaged func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged func removeFromOrders(_ values: NSSet)
}
