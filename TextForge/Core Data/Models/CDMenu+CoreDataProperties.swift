//
// CDMenu+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDMenu {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDMenu> {
        NSFetchRequest<CDMenu>(entityName: "CDMenu")
    }

    @NSManaged var selection: Int
    @NSManaged var options: NSSet?
}

// MARK: Generated accessors for options

nonisolated public extension CDMenu {
    @objc(addOptionsObject:)
    @NSManaged func addToOptions(_ value: CDMenuOption)

    @objc(removeOptionsObject:)
    @NSManaged func removeFromOptions(_ value: CDMenuOption)

    @objc(addOptions:)
    @NSManaged func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged func removeFromOptions(_ values: NSSet)
}
