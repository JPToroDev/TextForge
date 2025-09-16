//
// CDTag+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDTag {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDTag> {
        NSFetchRequest<CDTag>(entityName: "CDTag")
    }

    @NSManaged var templates: NSSet?
}

// MARK: Generated accessors for templates

nonisolated public extension CDTag {
    @objc(addTemplatesObject:)
    @NSManaged func addToTemplates(_ value: CDTemplate)

    @objc(removeTemplatesObject:)
    @NSManaged func removeFromTemplates(_ value: CDTemplate)

    @objc(addTemplates:)
    @NSManaged func addToTemplates(_ values: NSSet)

    @objc(removeTemplates:)
    @NSManaged func removeFromTemplates(_ values: NSSet)
}
